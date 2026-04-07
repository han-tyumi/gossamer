import type * as $blob from "$/gossamer/gossamer/blob.mjs";
import { toResult } from "~/utils/result.ts";

export type Blob$ = Blob;

export const new_: typeof $blob.new$ = () => {
  return new Blob();
};

export const from_string: typeof $blob.from_string = (content) => {
  return new Blob([content]);
};

export const from_string_with_type: typeof $blob.from_string_with_type = (
  content,
  mimeType,
) => {
  return new Blob([content], { type: mimeType });
};

export const from_bytes: typeof $blob.from_bytes = (bytes) => {
  return new Blob([bytes as unknown as BlobPart]);
};

export const from_bytes_with_type: typeof $blob.from_bytes_with_type = (
  bytes,
  mimeType,
) => {
  return new Blob([bytes as unknown as BlobPart], { type: mimeType });
};

export const size: typeof $blob.size = (blob) => {
  return blob.size;
};

export const type_: typeof $blob.type_ = (blob) => {
  return blob.type;
};

export const array_buffer: typeof $blob.array_buffer = (blob) => {
  return toResult.fromPromise(blob.arrayBuffer());
};

export const bytes: typeof $blob.bytes = (blob) => {
  return toResult.fromPromise(blob.bytes());
};

export const slice: typeof $blob.slice = (blob, start, end) => {
  return blob.slice(start, end);
};

export const slice_with_type: typeof $blob.slice_with_type = (
  blob,
  start,
  end,
  contentType,
) => {
  return blob.slice(start, end, contentType);
};

export const stream: typeof $blob.stream = (blob) => {
  return blob.stream() as unknown as ReadableStream<Uint8Array>;
};

export const text: typeof $blob.text = (blob) => {
  return toResult.fromPromise(blob.text());
};
