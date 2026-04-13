import type * as $iterator from "$/gossamer/gossamer/iterator.mjs";
import type { List } from "$/prelude.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import {
  List$isNonEmpty,
  List$NonEmpty$first,
  List$NonEmpty$rest,
  Result$Error,
  Result$Ok,
} from "$/prelude.mjs";
import {
  toGleamIteratorResult,
  toIteratorResult,
} from "~/gossamer/iterator_result.ts";
import { fromArray } from "~/utils/list.ts";
import { toOption } from "~/utils/option.ts";

export type Iterator$<T, TReturn, TNext> = Iterator<T, TReturn, TNext>;

export const new_: typeof $iterator.new$ = <TNext, T, TReturn>(
  ...[next]: Parameters<typeof $iterator.new$<TNext, T, TReturn>>
) => {
  const iterator = {
    next: (...[value]: [TNext?]) => toIteratorResult(next(toOption(value))),
    [Symbol.iterator]() {
      return this;
    },
  };
  return iterator as unknown as Iterator<T, TReturn, TNext>;
};

export const from_list: typeof $iterator.from_list = <T>(list: List<T>) => {
  let current = list;
  const iterator = {
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
  return iterator as unknown as Iterator<T, undefined, undefined>;
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
  const newIterator = {
    ...iterator,
    return: (value?: TReturn) => toIteratorResult(return_(toOption(value))),
    [Symbol.iterator]() {
      return this;
    },
  };
  return newIterator as unknown as Iterator<T, TReturn, TNext>;
};

export const with_throw: typeof $iterator.with_throw = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  throw_: Parameters<typeof $iterator.with_throw<T, TReturn, TNext>>[1],
) => {
  const newIterator = {
    ...iterator,
    throw: (value?: unknown) => toIteratorResult(throw_(value)),
    [Symbol.iterator]() {
      return this;
    },
  };
  return newIterator as unknown as Iterator<T, TReturn, TNext>;
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
  reason: Parameters<typeof $iterator.throw$<T, TReturn>>[1],
) => {
  if (!iterator.throw) {
    return Result$Error(undefined);
  }

  const result = iterator.throw($option.unwrap(reason, undefined));
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
