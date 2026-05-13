import type * as $asyncIterator from "$/gossamer/gossamer/iteration/async_iterator.mjs";
import type { List } from "$/prelude.mjs";
import {
  List$isNonEmpty,
  List$NonEmpty$first,
  List$NonEmpty$rest,
} from "$/prelude.mjs";
import {
  toCallbackResultPromise,
  toIteratorResult,
} from "~/gossamer/iteration.ffi.ts";
import { fromArray } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";

export const new_: typeof $asyncIterator.new$ = <TNext, T, TReturn>(
  ...[next]: Parameters<typeof $asyncIterator.new$<TNext, T, TReturn>>
) => {
  const iterator: AsyncIterableIterator<T, TReturn, TNext> = {
    next: async (...[value]: [TNext?]) =>
      toIteratorResult(await next(toOption(value))),
    [Symbol.asyncIterator]() {
      return this;
    },
  };
  return iterator;
};

export const from_list: typeof $asyncIterator.from_list = <T>(
  list: List<T>,
) => {
  let current = list;
  const iterator: AsyncIterableIterator<T, undefined, undefined> = {
    next() {
      if (List$isNonEmpty(current)) {
        // deno-lint-ignore no-non-null-assertion
        const value = List$NonEmpty$first(current)!;
        // deno-lint-ignore no-non-null-assertion
        current = List$NonEmpty$rest(current)!;
        return Promise.resolve({ done: false as const, value });
      }
      return Promise.resolve({ done: true as const, value: undefined });
    },
    [Symbol.asyncIterator]() {
      return this;
    },
  };
  return iterator;
};

export const to_list: typeof $asyncIterator.to_list = <T>(
  iterator: AsyncIterator<T, unknown, unknown>,
) => {
  return toCallbackResultPromise((async () => {
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
  })());
};

export const for_await: typeof $asyncIterator.for_await = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  fun: Parameters<typeof $asyncIterator.for_await<T>>[1],
) => {
  return toCallbackResultPromise((async () => {
    while (true) {
      // deno-lint-ignore no-await-in-loop
      const result = await iterator.next();
      if (result.done) {
        break;
      }
      // deno-lint-ignore no-await-in-loop
      await fun(result.value);
    }
    return undefined;
  })());
};
