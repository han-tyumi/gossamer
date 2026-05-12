import type * as $transformStream from "$/gossamer/gossamer/stream/transform_stream.mjs";
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

export const build: typeof $transformStream.do_build = (
  start,
  transform,
  flush,
  cancel,
  writable_strategy,
  readable_strategy,
) => {
  const transformer: Transformer = {};
  setIfSome(transformer, "start", start);
  setIfSome(transformer, "transform", transform);
  setIfSome(transformer, "flush", flush);
  setIfSome(transformer, "cancel", cancel);
  const writableStrategy = strategyOf(writable_strategy);
  const readableStrategy = strategyOf(readable_strategy);
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
