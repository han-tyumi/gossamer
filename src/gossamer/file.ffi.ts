import type * as $file from "$/gossamer/gossamer/file.mjs";
import { toFileOptions } from "~/gossamer/file_option.ts";
import { toArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

export type File$ = File;

export const from_strings: typeof $file.from_strings = (parts, name) => {
  return new File(toArray(parts), name);
};

export const from_strings_with: typeof $file.from_strings_with = (
  parts,
  name,
  options,
) => {
  return new File(toArray(parts), name, toFileOptions(toArray(options)));
};

export const from_blob: typeof $file.from_blob = (blob, name) => {
  return new File([blob], name);
};

export const from_blob_with: typeof $file.from_blob_with = (
  blob,
  name,
  options,
) => {
  return new File([blob], name, toFileOptions(toArray(options)));
};

export const name: typeof $file.name = (file) => {
  return file.name;
};

export const last_modified: typeof $file.last_modified = (file) => {
  return file.lastModified;
};

export const to_blob: typeof $file.to_blob = (file) => {
  return file;
};

export const size: typeof $file.size = (file) => {
  return file.size;
};

export const type_: typeof $file.type_ = (file) => {
  return file.type;
};

export const array_buffer: typeof $file.array_buffer = (file) => {
  return toResult.fromPromise(file.arrayBuffer());
};

export const bytes: typeof $file.bytes = (file) => {
  return toResult.fromPromise(file.bytes());
};

export const slice: typeof $file.slice = (file, start, end) => {
  return file.slice(start, end);
};

export const slice_with_type: typeof $file.slice_with_type = (
  file,
  start,
  end,
  contentType,
) => {
  return file.slice(start, end, contentType);
};

export const stream: typeof $file.stream = (file) => {
  return file.stream() as unknown as ReadableStream<Uint8Array>;
};

export const text: typeof $file.text = (file) => {
  return toResult.fromPromise(file.text());
};
