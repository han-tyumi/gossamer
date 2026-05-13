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

export function toCallbackResultPromise<T>(promise: Promise<T>) {
  return promise.then(
    (value) => Result$Ok(value),
    (error) => Result$Error(error),
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
