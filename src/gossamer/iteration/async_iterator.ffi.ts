import type * as $asyncIterator from "$/gossamer/gossamer/iteration/async_iterator.mjs";
import {
  asyncYielderAsJsAsyncIterator,
  jsAsyncIteratorAsAsyncYielder,
  toIteratorResult,
} from "~/gossamer/iteration.ffi.ts";
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

export const from_async_yielder: typeof $asyncIterator.from_async_yielder =
  asyncYielderAsJsAsyncIterator;

export const to_async_yielder: typeof $asyncIterator.to_async_yielder =
  jsAsyncIteratorAsAsyncYielder;

export const each: typeof $asyncIterator.each = async <T, TReturn, TNext>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  fun: Parameters<typeof $asyncIterator.each<T>>[1],
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
  return undefined;
};
