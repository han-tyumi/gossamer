import type * as $iterator from "$/gossamer/gossamer/iterator.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  toGleamIteratorResult,
  toIteratorResult,
} from "~/gossamer/iterator_result.ts";
import { toOption } from "~/utils/option.ts";

export type Iterator$<T, TReturn, TNext> = Iterator<T, TReturn, TNext>;

export const new_: typeof $iterator.new$ = <TNext, T, TReturn>(
  ...[next]: Parameters<typeof $iterator.new$<TNext, T, TReturn>>
) => {
  const iterator: Iterator<T, TReturn, TNext> = {
    next: (...[value]) => toIteratorResult(next(toOption(value))),
  };
  return iterator;
};

export const with_return: typeof $iterator.with_return = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  return_: Parameters<typeof $iterator.with_return<T, TReturn, TNext>>[1],
) => {
  const newIterator: Iterator<T, TReturn, TNext> = {
    ...iterator,
    return: (value) => toIteratorResult(return_(toOption(value))),
  };
  return newIterator;
};

export const with_throw: typeof $iterator.with_throw = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  throw_: Parameters<typeof $iterator.with_throw<T, TReturn, TNext>>[1],
) => {
  const newIterator: Iterator<T, TReturn, TNext> = {
    ...iterator,
    throw: (value) => toIteratorResult(throw_(toOption(value))),
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
  if (!iterator.return) {
    return Result$Error(undefined);
  }

  const result = iterator.return();
  return Result$Ok(toGleamIteratorResult(result));
};

export const return_with: typeof $iterator.return_with = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  value: Parameters<typeof $iterator.return_with<T, TReturn>>[1],
) => {
  if (!iterator.return) {
    return Result$Error(undefined);
  }

  const result = iterator.return(value);
  return Result$Ok(toGleamIteratorResult(result));
};

export const throw_: typeof $iterator.throw$ = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  value: Parameters<typeof $iterator.throw$<T, TReturn>>[1],
) => {
  if (!iterator.throw) {
    return Result$Error(undefined);
  }

  const result = iterator.throw($option.unwrap(value, undefined));
  return Result$Ok(toGleamIteratorResult(result));
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
