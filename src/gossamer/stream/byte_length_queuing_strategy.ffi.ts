import * as $byteLengthQueuingStrategy from "$/gossamer/gossamer/stream/byte_length_queuing_strategy.mjs";

export const new_: typeof $byteLengthQueuingStrategy.new$ = (highWaterMark) => {
  const value = $byteLengthQueuingStrategy.HighWaterMark$isUnlimited(
      highWaterMark,
    )
    ? Infinity
    : $byteLengthQueuingStrategy.HighWaterMark$Bytes$0(highWaterMark);
  return new ByteLengthQueuingStrategy({ highWaterMark: value });
};

export const high_water_mark:
  typeof $byteLengthQueuingStrategy.high_water_mark = (strategy) => {
    const value = strategy.highWaterMark;
    if (!Number.isFinite(value)) {
      return $byteLengthQueuingStrategy.HighWaterMark$Unlimited();
    }
    return $byteLengthQueuingStrategy.HighWaterMark$Bytes(Math.trunc(value));
  };
