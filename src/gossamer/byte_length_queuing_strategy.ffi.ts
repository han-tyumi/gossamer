import type * as $byteLengthQueuingStrategy from "$/gossamer/gossamer/byte_length_queuing_strategy.mjs";

export type ByteLengthQueuingStrategy$ = ByteLengthQueuingStrategy;

export const new_: typeof $byteLengthQueuingStrategy.new$ = (highWaterMark) => {
  return new ByteLengthQueuingStrategy({ highWaterMark });
};

export const high_water_mark:
  typeof $byteLengthQueuingStrategy.high_water_mark = (strategy) => {
    return strategy.highWaterMark;
  };
