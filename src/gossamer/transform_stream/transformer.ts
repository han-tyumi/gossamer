import * as $transformer from "$/gossamer/gossamer/transform_stream/transformer.mjs";

export function toTransformer<I, O>(
  options: $transformer.Transformer$<I, O>[],
): Transformer<I, O> {
  const result: Transformer<I, O> = {};
  for (const option of options) {
    if ($transformer.Transformer$isStart(option)) {
      result.start = $transformer.Transformer$Start$0(option);
    } else if ($transformer.Transformer$isTransform(option)) {
      result.transform = $transformer.Transformer$Transform$0(option);
    } else if ($transformer.Transformer$isFlush(option)) {
      result.flush = $transformer.Transformer$Flush$0(option);
    } else if ($transformer.Transformer$isCancel(option)) {
      result.cancel = $transformer.Transformer$Cancel$0(option);
    }
  }
  return result;
}
