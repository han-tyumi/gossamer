import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import * as $iteratorHandlerOutcome from "$/gossamer/gossamer/iterator_handler_outcome.mjs";
import type * as $iterator from "$/gossamer/gossamer/iterator.mjs";
import type { List } from "$/prelude.mjs";
import {
  List$isNonEmpty,
  List$NonEmpty$first,
  List$NonEmpty$rest,
} from "$/prelude.mjs";
import {
  toGleamIteratorResult,
  toIteratorResult,
} from "~/gossamer/iterator_result.ffi.ts";
import { fromArray } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function withHelpers<T>(
  iterator: Iterator<T, unknown, unknown>,
): IteratorObject<T, undefined, unknown> {
  return Iterator.from(iterator);
}

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

export const from_list: typeof $iterator.from_list = <T>(list: List<T>) => {
  let current = list;
  const iterator: IterableIterator<T, undefined, undefined> = {
    next() {
      if (List$isNonEmpty(current)) {
        // deno-lint-ignore no-non-null-assertion
        const value = List$NonEmpty$first(current)!;
        // deno-lint-ignore no-non-null-assertion
        current = List$NonEmpty$rest(current)!;
        return { done: false as const, value };
      }
      return { done: true as const, value: undefined };
    },
    [Symbol.iterator]() {
      return this;
    },
  };
  return iterator;
};

export const to_list: typeof $iterator.to_list = <T>(
  iterator: Iterator<T, unknown, unknown>,
) => {
  const values: T[] = [];
  while (true) {
    const result = iterator.next();
    if (result.done) {
      break;
    }
    values.push(result.value);
  }
  return fromArray(values);
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
    return toResult.fromThrows(() =>
      $iteratorHandlerOutcome.IteratorHandlerOutcome$NoHandler()
    );
  }
  return toResult.fromThrows(() =>
    $iteratorHandlerOutcome.IteratorHandlerOutcome$Handled(
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
    return toResult.fromThrows(() =>
      $iteratorHandlerOutcome.IteratorHandlerOutcome$NoHandler()
    );
  }
  return toResult.fromThrows(() =>
    $iteratorHandlerOutcome.IteratorHandlerOutcome$Handled(
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
    return toResult.fromThrows(() =>
      $iteratorHandlerOutcome.IteratorHandlerOutcome$NoHandler()
    );
  }
  return toResult.fromThrows(() =>
    $iteratorHandlerOutcome.IteratorHandlerOutcome$Handled(
      toGleamIteratorResult(
        throwFn.call(iterator, $option.unwrap(reason, undefined)),
      ),
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

export const map: typeof $iterator.map = <T, U>(
  iterator: Iterator<T, unknown, unknown>,
  callback: (value: T) => U,
) => {
  return withHelpers(iterator).map(callback) as IterableIterator<
    U,
    undefined,
    undefined
  >;
};

export const filter: typeof $iterator.filter = <T>(
  iterator: Iterator<T, unknown, unknown>,
  predicate: (value: T) => boolean,
) => {
  return withHelpers(iterator).filter(predicate) as IterableIterator<
    T,
    undefined,
    undefined
  >;
};

export const take: typeof $iterator.take = <T>(
  iterator: Iterator<T, unknown, unknown>,
  limit: number,
) => {
  return withHelpers(iterator).take(limit) as IterableIterator<
    T,
    undefined,
    undefined
  >;
};

export const drop: typeof $iterator.drop = <T>(
  iterator: Iterator<T, unknown, unknown>,
  count: number,
) => {
  return withHelpers(iterator).drop(count) as IterableIterator<
    T,
    undefined,
    undefined
  >;
};

export const flat_map: typeof $iterator.flat_map = <T, U>(
  iterator: Iterator<T, unknown, unknown>,
  callback: (value: T) => Iterator<U, undefined, undefined>,
) => {
  return withHelpers(iterator).flatMap(callback) as IterableIterator<
    U,
    undefined,
    undefined
  >;
};

export const reduce: typeof $iterator.reduce = <T, U>(
  iterator: Iterator<T, unknown, unknown>,
  initial: U,
  callback: (accumulator: U, value: T) => U,
) => {
  return withHelpers(iterator).reduce(callback, initial);
};

export const some: typeof $iterator.some = <T>(
  iterator: Iterator<T, unknown, unknown>,
  predicate: (value: T) => boolean,
) => {
  return withHelpers(iterator).some(predicate);
};

export const every: typeof $iterator.every = <T>(
  iterator: Iterator<T, unknown, unknown>,
  predicate: (value: T) => boolean,
) => {
  return withHelpers(iterator).every(predicate);
};

export const find: typeof $iterator.find = <T>(
  iterator: Iterator<T, unknown, unknown>,
  predicate: (value: T) => boolean,
) => {
  return toResult(withHelpers(iterator).find(predicate));
};
