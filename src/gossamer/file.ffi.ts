import {
  from_unix_seconds_and_nanoseconds,
  type Timestamp$,
  to_unix_seconds_and_nanoseconds,
} from "$/gleam_time/gleam/time/timestamp.mjs";
import * as $file from "$/gossamer/gossamer/file.mjs";
import { toArray } from "~/utils/list.ffi.ts";

function msToTimestamp(ms: number): Timestamp$ {
  const seconds = Math.floor(ms / 1000);
  const nanoseconds = (ms - seconds * 1000) * 1_000_000;
  return from_unix_seconds_and_nanoseconds(seconds, nanoseconds);
}

function timestampToMs(timestamp: Timestamp$): number {
  const [seconds, nanoseconds] = to_unix_seconds_and_nanoseconds(timestamp);
  return seconds * 1000 + nanoseconds / 1_000_000;
}

export const from_strings: typeof $file.from_strings = (parts, name) => {
  return $file.File$File(
    new Blob(toArray(parts)),
    name,
    "",
    msToTimestamp(Date.now()),
  );
};

export const from_blob: typeof $file.from_blob = (blob, name) => {
  return $file.File$File(blob, name, blob.type, msToTimestamp(Date.now()));
};

export function toJsFile(file: $file.File$): File {
  return new File(
    [$file.File$File$blob(file)],
    $file.File$File$name(file),
    {
      type: $file.File$File$type_(file),
      lastModified: timestampToMs($file.File$File$last_modified(file)),
    },
  );
}
