import type * as $iterator from "$/gossamer/gossamer/iterator.mjs";
import {
  jsIteratorAsYielder,
  yielderAsJsIterator,
} from "~/utils/iteration.ffi.ts";

export const from_yielder: typeof $iterator.from_yielder = yielderAsJsIterator;

export const to_yielder: typeof $iterator.to_yielder = jsIteratorAsYielder;

export const each: typeof $iterator.each = <T>(
  iterator: Iterator<T>,
  fun: Parameters<typeof $iterator.each<T>>[1],
) => {
  while (true) {
    const result = iterator.next();
    if (result.done) {
      break;
    }
    fun(result.value);
  }
};
