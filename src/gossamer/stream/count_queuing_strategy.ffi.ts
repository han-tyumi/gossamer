import * as $countQueuingStrategy from "$/gossamer/gossamer/stream/count_queuing_strategy.mjs";

export const new_: typeof $countQueuingStrategy.new$ = (highWaterMark) => {
  const value = $countQueuingStrategy.HighWaterMark$isUnlimited(highWaterMark)
    ? Infinity
    : $countQueuingStrategy.HighWaterMark$Chunks$0(highWaterMark);
  return new CountQueuingStrategy({ highWaterMark: value });
};

export const high_water_mark: typeof $countQueuingStrategy.high_water_mark = (
  strategy,
) => {
  const value = strategy.highWaterMark;
  if (!Number.isFinite(value)) {
    return $countQueuingStrategy.HighWaterMark$Unlimited();
  }
  return $countQueuingStrategy.HighWaterMark$Chunks(Math.trunc(value));
};
