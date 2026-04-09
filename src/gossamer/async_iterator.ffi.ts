import type * as $asyncIterator from "$/gossamer/gossamer/async_iterator.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  toGleamIteratorResult,
  toIteratorResult,
} from "~/gossamer/iterator_result.ts";
import { toOption } from "~/utils/option.ts";

export type AsyncIterator$<T, TReturn, TNext> = AsyncIterator<
  T,
  TReturn,
  TNext
>;

export const new_: typeof $asyncIterator.new$ = <TNext, T, TReturn>(
  ...[next]: Parameters<typeof $asyncIterator.new$<TNext, T, TReturn>>
) => {
  const iterator: AsyncIterator<T, TReturn, TNext> = {
    next: async (...[value]) => toIteratorResult(await next(toOption(value))),
  };
  return iterator;
};

export const with_return: typeof $asyncIterator.with_return = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  return_: Parameters<typeof $asyncIterator.with_return<T, TReturn, TNext>>[1],
) => {
  const newIterator: AsyncIterator<T, TReturn, TNext> = {
    ...iterator,
    return: async (value) => toIteratorResult(await return_(toOption(value))),
  };
  return newIterator;
};

export const with_throw: typeof $asyncIterator.with_throw = <T, TReturn, TNext>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  throw_: Parameters<typeof $asyncIterator.with_throw<T, TReturn, TNext>>[1],
) => {
  const newIterator: AsyncIterator<T, TReturn, TNext> = {
    ...iterator,
    throw: async (value) => toIteratorResult(await throw_(toOption(value))),
  };
  return newIterator;
};

export const next: typeof $asyncIterator.next = async <T, TReturn, TNext>(
  iterator: AsyncIterator<T, TReturn, TNext>,
) => {
  const result = await iterator.next();
  return toGleamIteratorResult(result);
};

export const next_with: typeof $asyncIterator.next_with = async <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  value: Parameters<typeof $asyncIterator.next_with<T, TReturn, TNext>>[1],
) => {
  const result = await iterator.next(value);
  return toGleamIteratorResult(result);
};

export const return_: typeof $asyncIterator.return$ = async <T, TReturn, TNext>(
  iterator: AsyncIterator<T, TReturn, TNext>,
) => {
  if (!iterator.return) {
    return Result$Error(undefined);
  }

  const result = await iterator.return();
  return Result$Ok(toGleamIteratorResult(result));
};

export const return_with: typeof $asyncIterator.return_with = async <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  value: Parameters<typeof $asyncIterator.return_with<T, TReturn>>[1],
) => {
  if (!iterator.return) {
    return Result$Error(undefined);
  }

  const result = await iterator.return(value);
  return Result$Ok(toGleamIteratorResult(result));
};

export const throw_: typeof $asyncIterator.throw$ = async <T, TReturn, TNext>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  reason: Parameters<typeof $asyncIterator.throw$<T, TReturn>>[1],
) => {
  if (!iterator.throw) {
    return Result$Error(undefined);
  }

  const result = await iterator.throw($option.unwrap(reason, undefined));
  return Result$Ok(toGleamIteratorResult(result));
};

export const for_await: typeof $asyncIterator.for_await = async <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  fun: Parameters<typeof $asyncIterator.for_await<T>>[1],
) => {
  while (true) {
    // deno-lint-ignore no-await-in-loop
    const result = await iterator.next();
    if (result.done) {
      break;
    }
    // deno-lint-ignore no-await-in-loop
    await fun(result.value);
  }
};
