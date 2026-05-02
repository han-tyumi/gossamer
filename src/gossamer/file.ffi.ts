import * as $blob from "$/gossamer/gossamer/blob.mjs";
import * as $file from "$/gossamer/gossamer/file.mjs";
import { toBlob } from "~/gossamer/blob.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function toFileOptions(options: $file.FileOption$[]): FilePropertyBag {
  const result: FilePropertyBag = {};
  for (const option of options) {
    if ($file.FileOption$isType(option)) {
      result.type = $file.FileOption$Type$0(option);
    } else if ($file.FileOption$isLastModified(option)) {
      result.lastModified = $file.FileOption$LastModified$0(option);
    }
  }
  return result;
}

export function toFile(file: File): $file.File$ {
  return $file.File$File(
    file.name,
    file.lastModified,
    file.size,
    file.type,
    file,
  );
}

export const from_strings: typeof $file.from_strings = (parts, name) => {
  return toFile(new File(toArray(parts), name));
};

export const from_strings_with: typeof $file.from_strings_with = (
  parts,
  name,
  options,
) => {
  return toFile(
    new File(toArray(parts), name, toFileOptions(toArray(options))),
  );
};

export const from_blob: typeof $file.from_blob = (blob, name) => {
  return toFile(new File([$blob.Blob$Blob$ref(blob)], name));
};

export const from_blob_with: typeof $file.from_blob_with = (
  blob,
  name,
  options,
) => {
  return toFile(
    new File(
      [$blob.Blob$Blob$ref(blob)],
      name,
      toFileOptions(toArray(options)),
    ),
  );
};

export const to_blob: typeof $file.to_blob = (file) => {
  return toBlob($file.File$File$ref(file));
};

export const array_buffer: typeof $file.array_buffer = (file) => {
  return toResult.fromPromise($file.File$File$ref(file).arrayBuffer());
};

export const bytes: typeof $file.bytes = (file) => {
  return toResult.fromPromise($file.File$File$ref(file).bytes());
};

export const slice: typeof $file.slice = (file, start, end) => {
  return toBlob($file.File$File$ref(file).slice(start, end));
};

export const slice_with_type: typeof $file.slice_with_type = (
  file,
  start,
  end,
  contentType,
) => {
  return toBlob($file.File$File$ref(file).slice(start, end, contentType));
};

export const stream: typeof $file.stream = (file) => {
  return $file.File$File$ref(file).stream() as unknown as ReadableStream<
    Uint8Array
  >;
};

export const text: typeof $file.text = (file) => {
  return toResult.fromPromise($file.File$File$ref(file).text());
};
