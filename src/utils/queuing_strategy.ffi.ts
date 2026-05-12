import * as $stream from "$/gossamer/gossamer/stream.mjs";

export function fromQueuingStrategy(
  strategy: $stream.QueuingStrategy$,
): QueuingStrategy {
  if ($stream.QueuingStrategy$isUnlimited(strategy)) {
    return new CountQueuingStrategy({ highWaterMark: Infinity });
  }
  if ($stream.QueuingStrategy$isByCount(strategy)) {
    return new CountQueuingStrategy({
      highWaterMark: $stream.QueuingStrategy$ByCount$high_water_mark(strategy),
    });
  }
  return new ByteLengthQueuingStrategy({
    highWaterMark: $stream.QueuingStrategy$ByByteLength$high_water_mark(
      strategy,
    ),
  });
}
