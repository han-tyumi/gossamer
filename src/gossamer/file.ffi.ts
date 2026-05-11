import * as $file from "$/gossamer/gossamer/file.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { msToTimestamp, timestampToMs } from "~/utils/time.ffi.ts";

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
