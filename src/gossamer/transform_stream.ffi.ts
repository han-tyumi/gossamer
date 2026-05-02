import * as $transformStream from "$/gossamer/gossamer/transform_stream.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export type TransformStream$<I, O> = TransformStream<I, O>;

function toTransformer<I, O>(
  options: $transformStream.Transformer$<I, O>[],
): Transformer<I, O> {
  const result: Transformer<I, O> = {};
  for (const option of options) {
    if ($transformStream.Transformer$isStart(option)) {
      result.start = $transformStream.Transformer$Start$0(option);
    } else if ($transformStream.Transformer$isTransform(option)) {
      result.transform = $transformStream.Transformer$Transform$0(option);
    } else if ($transformStream.Transformer$isFlush(option)) {
      result.flush = $transformStream.Transformer$Flush$0(option);
    } else if ($transformStream.Transformer$isCancel(option)) {
      result.cancel = $transformStream.Transformer$Cancel$0(option);
    }
  }
  return result;
}

export const new_: typeof $transformStream.new$ = (transformer) => {
  return toResult.fromThrows(() =>
    new TransformStream(toTransformer(toArray(transformer)))
  );
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
