import type * as $file from "$/gossamer/gossamer/file.mjs";
import { toArray } from "~/utils/list.ts";

export type File$ = File;

export const from_strings: typeof $file.from_strings = (parts, name) => {
  return new File(toArray(parts), name);
};

export const from_blob: typeof $file.from_blob = (blob, name) => {
  return new File([blob], name);
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
