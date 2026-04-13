import type * as $asyncIterator from "$/gossamer/gossamer/async_iterator.mjs";
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

export type AsyncIterator$<T, TReturn, TNext> = AsyncIterator<
  T,
  TReturn,
  TNext
>;

export const new_: typeof $asyncIterator.new$ = <TNext, T, TReturn>(
  ...[next]: Parameters<typeof $asyncIterator.new$<TNext, T, TReturn>>
) => {
  const iterator = {
    next: async (...[value]: [TNext?]) =>
      toIteratorResult(await next(toOption(value))),
    [Symbol.asyncIterator]() {
      return this;
    },
  };
  return iterator as unknown as AsyncIterator<T, TReturn, TNext>;
};

export const from_list: typeof $asyncIterator.from_list = <T>(
  list: List<T>,
) => {
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
    [Symbol.asyncIterator]() {
      return this;
    },
  };
  return iterator as unknown as AsyncIterator<T, undefined, undefined>;
};

export const to_list: typeof $asyncIterator.to_list = async <T>(
  iterator: AsyncIterator<T, unknown, unknown>,
) => {
  const values: T[] = [];
  while (true) {
    // deno-lint-ignore no-await-in-loop
    const result = await iterator.next();
    if (result.done) {
      break;
    }
    values.push(result.value);
  }
  return fromArray(values);
};

export const with_return: typeof $asyncIterator.with_return = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  return_: Parameters<typeof $asyncIterator.with_return<T, TReturn, TNext>>[1],
) => {
  const newIterator = {
    ...iterator,
    return: async (value?: TReturn) =>
      toIteratorResult(await return_(toOption(value))),
    [Symbol.asyncIterator]() {
      return this;
    },
  };
  return newIterator as unknown as AsyncIterator<T, TReturn, TNext>;
};

export const with_throw: typeof $asyncIterator.with_throw = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  throw_: Parameters<typeof $asyncIterator.with_throw<T, TReturn, TNext>>[1],
) => {
  const newIterator = {
    ...iterator,
    throw: async (value?: unknown) => toIteratorResult(await throw_(value)),
    [Symbol.asyncIterator]() {
      return this;
    },
  };
  return newIterator as unknown as AsyncIterator<T, TReturn, TNext>;
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
