import type * as $blob from "$/gossamer/gossamer/blob.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";
import { toBitArrayStream, toBufferSource } from "~/utils/bit_array.ffi.ts";

function readBody<T>(promise: Promise<T>) {
  return promise.then(
    (value) => Result$Ok(value),
    () => Result$Error(undefined),
  );
}

export const new_: typeof $blob.new$ = () => {
  return new Blob();
};

export const from_bytes: typeof $blob.from_bytes = (bytes, contentType) => {
  return new Blob([toBufferSource(bytes)], { type: contentType });
};

export const from_string: typeof $blob.from_string = (content, contentType) => {
  return new Blob([content], { type: contentType });
};

export const size: typeof $blob.size = (blob) => {
  return blob.size;
};

export const mime_type: typeof $blob.mime_type = (blob) => {
  return blob.type;
};

export const array_buffer: typeof $blob.array_buffer = (blob) => {
  return readBody(blob.arrayBuffer());
};

export const bytes: typeof $blob.bytes = (blob) => {
  return readBody(blob.bytes().then(BitArray$BitArray));
};

export const slice: typeof $blob.slice = (blob, start, end, contentType) => {
  return blob.slice(start, end, contentType);
};

export const stream: typeof $blob.stream = (blob) => {
  return toBitArrayStream(blob.stream());
};

export const text: typeof $blob.text = (blob) => {
  return readBody(blob.text());
};

export const to_object_url: typeof $blob.to_object_url = (blob) => {
  return URL.createObjectURL(blob);
};

export const revoke_object_url: typeof $blob.revoke_object_url = (url) => {
  URL.revokeObjectURL(url);
};
