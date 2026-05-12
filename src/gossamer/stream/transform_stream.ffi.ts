import * as $transformStream from "$/gossamer/gossamer/stream/transform_stream.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { setIfSome } from "~/utils/option.ffi.ts";
import { fromQueuingStrategy } from "~/utils/queuing_strategy.ffi.ts";

function strategyOf(opt: $option.Option$<$stream.QueuingStrategy$>) {
  return $option.Option$isNone(opt)
    ? undefined
    : fromQueuingStrategy($option.Option$Some$0(opt));
}

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
  const writableStrategy = strategyOf(
    $transformStream.Builder$Builder$writable_strategy(builder),
  );
  const readableStrategy = strategyOf(
    $transformStream.Builder$Builder$readable_strategy(builder),
  );
  try {
    return Result$Ok(
      new TransformStream(transformer, writableStrategy, readableStrategy),
    );
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
