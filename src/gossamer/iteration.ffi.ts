import * as $iteration from "$/gossamer/gossamer/iteration.mjs";

export function toIteratorResult<T, TReturn>(
  result: $iteration.IteratorResult$<T, TReturn>,
): IteratorResult<T, TReturn> {
  if ($iteration.IteratorResult$isReturn(result)) {
    return {
      done: true,
      value: $iteration.IteratorResult$Return$value(result),
    };
  }
  return {
    done: false,
    value: $iteration.IteratorResult$Yield$value(result),
  };
}

export function toGleamIteratorResult<T, TReturn>(
  result: IteratorResult<T, TReturn>,
): $iteration.IteratorResult$<T, TReturn> {
  if (result.done) {
    return $iteration.IteratorResult$Return(result.value);
  }
  return $iteration.IteratorResult$Yield(result.value);
}
