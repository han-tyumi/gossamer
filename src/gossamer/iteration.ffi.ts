import * as $yielder from "$/gleam_yielder/gleam/yielder.mjs";
import * as $iteration from "$/gossamer/gossamer/iteration.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

export function jsIteratorAsYielder<T>(
  jsIterator: Iterator<T, unknown, unknown>,
): $yielder.Yielder$<T> {
  return $yielder.unfold(jsIterator, (current) => {
    const result = (current as Iterator<T>).next();
    if (result.done) return $yielder.Step$Done();
    return $yielder.Step$Next(result.value, current);
  });
}

export function yielderAsJsIterator<T>(
  yielder: $yielder.Yielder$<T>,
): IterableIterator<T, undefined, undefined> {
  let current = yielder;
  const iter: IterableIterator<T, undefined, undefined> = {
    next() {
      const step = $yielder.step(current);
      if ($yielder.Step$isDone(step)) {
        return { done: true as const, value: undefined };
      }
      const value = $yielder.Step$Next$element(step) as T;
      current = $yielder.Step$Next$accumulator(step) as $yielder.Yielder$<T>;
      return { done: false as const, value };
    },
    [Symbol.iterator]() {
      return this;
    },
  };
  return iter;
}

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
