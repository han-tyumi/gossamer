import * as $yielder from "$/gleam_yielder/gleam/yielder.mjs";
import * as $iteration from "$/gossamer/gossamer/iteration.mjs";
import type * as $iterator from "$/gossamer/gossamer/iteration/iterator.mjs";
import { Result$Ok } from "$/prelude.mjs";
import {
  toCallbackResult,
  toGleamIteratorResult,
  toIteratorResult,
} from "~/gossamer/iteration.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";

export const new_: typeof $iterator.new$ = <TNext, T, TReturn>(
  ...[next]: Parameters<typeof $iterator.new$<TNext, T, TReturn>>
) => {
  const iterator: IterableIterator<T, TReturn, TNext> = {
    next: (...[value]: [TNext?]) => toIteratorResult(next(toOption(value))),
    [Symbol.iterator]() {
      return this;
    },
  };
  return iterator;
};

export const from_yielder: typeof $iterator.from_yielder = <T>(
  yielder: $yielder.Yielder$<T>,
) => {
  let current = yielder;
  const iterator: IterableIterator<T, undefined, undefined> = {
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
  return iterator;
};

export const with_return: typeof $iterator.with_return = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  return_: Parameters<typeof $iterator.with_return<T, TReturn, TNext>>[1],
) => {
  const newIterator: IterableIterator<T, TReturn, TNext> = {
    ...iterator,
    next: (...args) => iterator.next(...args),
    return: (value?: TReturn) => toIteratorResult(return_(toOption(value))),
    [Symbol.iterator]() {
      return this;
    },
  };
  return newIterator;
};

export const with_throw: typeof $iterator.with_throw = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  throw_: Parameters<typeof $iterator.with_throw<T, TReturn, TNext>>[1],
) => {
  const newIterator: IterableIterator<T, TReturn, TNext> = {
    ...iterator,
    next: (...args) => iterator.next(...args),
    throw: (value?: unknown) => toIteratorResult(throw_(value)),
    [Symbol.iterator]() {
      return this;
    },
  };
  return newIterator;
};

export const next: typeof $iterator.next = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
) => {
  const result = iterator.next();
  return toGleamIteratorResult(result);
};

export const next_with: typeof $iterator.next_with = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  value: Parameters<typeof $iterator.next_with<T, TReturn, TNext>>[1],
) => {
  const result = iterator.next(value);
  return toGleamIteratorResult(result);
};

export const return_: typeof $iterator.return$ = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
) => {
  const returnFn = iterator.return;
  if (!returnFn) {
    return Result$Ok(
      $iteration.IteratorHandlerOutcome$NoHandler(),
    );
  }
  return toCallbackResult(() =>
    $iteration.IteratorHandlerOutcome$Handled(
      toGleamIteratorResult(returnFn.call(iterator)),
    )
  );
};

export const return_with: typeof $iterator.return_with = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  value: Parameters<typeof $iterator.return_with<T, TReturn>>[1],
) => {
  const returnFn = iterator.return;
  if (!returnFn) {
    return Result$Ok(
      $iteration.IteratorHandlerOutcome$NoHandler(),
    );
  }
  return toCallbackResult(() =>
    $iteration.IteratorHandlerOutcome$Handled(
      toGleamIteratorResult(returnFn.call(iterator, value)),
    )
  );
};

export const throw_: typeof $iterator.throw$ = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  reason: Parameters<typeof $iterator.throw$<T, TReturn>>[1],
) => {
  const throwFn = iterator.throw;
  if (!throwFn) {
    return Result$Ok(
      $iteration.IteratorHandlerOutcome$NoHandler(),
    );
  }
  return toCallbackResult(() =>
    $iteration.IteratorHandlerOutcome$Handled(
      toGleamIteratorResult(throwFn.call(iterator, reason)),
    )
  );
};

export const for_: typeof $iterator.for$ = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  fun: Parameters<typeof $iterator.for$<T>>[1],
) => {
  while (true) {
    const result = iterator.next();
    if (result.done) {
      break;
    }
    fun(result.value);
  }
};
