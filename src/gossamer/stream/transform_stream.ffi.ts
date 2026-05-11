import * as $transformStream from "$/gossamer/gossamer/stream/transform_stream.mjs";
import { setIfSome } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const build: typeof $transformStream.build = (builder) => {
  return toResult.fromThrows(() => {
    const transformer: Transformer = {};
    setIfSome(
      transformer,
      "start",
      $transformStream.Builder$Builder$start(builder),
    );
    setIfSome(
      transformer,
      "transform",
      $transformStream.Builder$Builder$transform(builder),
    );
    setIfSome(
      transformer,
      "flush",
      $transformStream.Builder$Builder$flush(builder),
    );
    setIfSome(
      transformer,
      "cancel",
      $transformStream.Builder$Builder$cancel(builder),
    );
    return new TransformStream(transformer);
  });
};

export const from_transform: typeof $transformStream.from_transform = (
  transform,
) => {
  return new TransformStream({ transform });
};

export const readable: typeof $transformStream.readable = (stream) => {
  return stream.readable;
};

export const writable: typeof $transformStream.writable = (stream) => {
  return stream.writable;
};
