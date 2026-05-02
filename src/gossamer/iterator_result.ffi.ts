import * as $iteratorResult from "$/gossamer/gossamer/iterator_result.mjs";

export function toIteratorResult<T, TReturn>(
  result: $iteratorResult.IteratorResult$<T, TReturn>,
): IteratorResult<T, TReturn> {
  if ($iteratorResult.IteratorResult$isReturn(result)) {
    return {
      done: true,
      value: $iteratorResult.IteratorResult$Return$value(result),
    };
  }
  return {
    done: false,
    value: $iteratorResult.IteratorResult$Yield$value(result),
  };
}

export function toGleamIteratorResult<T, TReturn>(
  result: IteratorResult<T, TReturn>,
): $iteratorResult.IteratorResult$<T, TReturn> {
  if (result.done) {
    return $iteratorResult.IteratorResult$Return(result.value);
  }
  return $iteratorResult.IteratorResult$Yield(result.value);
}
