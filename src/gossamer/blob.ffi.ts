import * as $blob from "$/gossamer/gossamer/blob.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export function toBlob(blob: Blob): $blob.Blob$ {
  return $blob.Blob$Blob(blob.size, blob.type, blob);
}

export function blobRef(blob: $blob.Blob$): Blob {
  return $blob.Blob$Blob$ref(blob);
}

export const new_: typeof $blob.new$ = () => {
  return toBlob(new Blob());
};

export const from_string: typeof $blob.from_string = (content) => {
  return toBlob(new Blob([content]));
};

export const from_string_with_type: typeof $blob.from_string_with_type = (
  content,
  mimeType,
) => {
  return toBlob(new Blob([content], { type: mimeType }));
};

export const from_bytes: typeof $blob.from_bytes = (bytes) => {
  return toBlob(new Blob([bytes as unknown as BlobPart]));
};

export const from_bytes_with_type: typeof $blob.from_bytes_with_type = (
  bytes,
  mimeType,
) => {
  return toBlob(new Blob([bytes as unknown as BlobPart], { type: mimeType }));
};

export const array_buffer: typeof $blob.array_buffer = (blob) => {
  return toResult.fromPromise(blobRef(blob).arrayBuffer());
};

export const bytes: typeof $blob.bytes = (blob) => {
  return toResult.fromPromise(blobRef(blob).bytes());
};

export const slice: typeof $blob.slice = (blob, start, end) => {
  return toBlob(blobRef(blob).slice(start, end));
};

export const slice_with_type: typeof $blob.slice_with_type = (
  blob,
  start,
  end,
  contentType,
) => {
  return toBlob(blobRef(blob).slice(start, end, contentType));
};

export const stream: typeof $blob.stream = (blob) => {
  return blobRef(blob).stream() as unknown as ReadableStream<Uint8Array>;
};

export const text: typeof $blob.text = (blob) => {
  return toResult.fromPromise(blobRef(blob).text());
};
