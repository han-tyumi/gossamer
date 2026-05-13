import type * as $iterator from "$/gossamer/gossamer/iteration/iterator.mjs";
import {
  jsIteratorAsYielder,
  toIteratorResult,
  yielderAsJsIterator,
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

export const from_yielder: typeof $iterator.from_yielder = yielderAsJsIterator;

export const to_yielder: typeof $iterator.to_yielder = jsIteratorAsYielder;

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
