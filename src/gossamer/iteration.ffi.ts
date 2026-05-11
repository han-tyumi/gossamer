import * as $iteration from "$/gossamer/gossamer/iteration.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

function toIteratorError(value: unknown): $iteration.IteratorError$ {
  const error = value instanceof Error
    ? value
    : new Error(String(value), { cause: value });
  return $iteration.IteratorError$CallbackThrew(error);
}

export function toCallbackResult<T>(thunk: () => T) {
  try {
    return Result$Ok(thunk());
  } catch (error) {
    return Result$Error(toIteratorError(error));
  }
}

export function toCallbackResultPromise<T>(promise: Promise<T>) {
  return promise.then(
    (value) => Result$Ok(value),
    (error) => Result$Error(toIteratorError(error)),
  );
}

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
