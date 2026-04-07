import type * as $countQueuingStrategy from "$/gossamer/gossamer/count_queuing_strategy.mjs";

export type CountQueuingStrategy$ = CountQueuingStrategy;

export const new_: typeof $countQueuingStrategy.new$ = (highWaterMark) => {
  return new CountQueuingStrategy({ highWaterMark });
};

export const high_water_mark: typeof $countQueuingStrategy.high_water_mark = (
  strategy,
) => {
  return strategy.highWaterMark;
};
