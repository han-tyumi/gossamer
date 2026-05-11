import * as $transformStream from "$/gossamer/gossamer/stream/transform_stream.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { setIfSome } from "~/utils/option.ffi.ts";

export const build: typeof $transformStream.build = (builder) => {
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
  try {
    return Result$Ok(new TransformStream(transformer));
  } catch (err) {
    return Result$Error($stream.StreamLifecycleError$Errored(err));
  }
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
