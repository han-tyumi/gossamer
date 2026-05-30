import type * as $asyncIterator from "$/gossamer/gossamer/async_iterator.mjs";
import {
  asyncYielderAsJsAsyncIterator,
  jsAsyncIteratorAsAsyncYielder,
} from "~/utils/iteration.ffi.ts";

export const from_async_yielder: typeof $asyncIterator.from_async_yielder =
  asyncYielderAsJsAsyncIterator;

export const to_async_yielder: typeof $asyncIterator.to_async_yielder =
  jsAsyncIteratorAsAsyncYielder;

export const each: typeof $asyncIterator.each = async <T>(
  iterator: AsyncIterator<T>,
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
