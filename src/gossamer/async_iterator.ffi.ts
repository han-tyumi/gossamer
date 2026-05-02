import type * as $asyncIterator from "$/gossamer/gossamer/async_iterator.mjs";
import type { List } from "$/prelude.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import * as $iteratorHandlerOutcome from "$/gossamer/gossamer/iterator_handler_outcome.mjs";
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
  return toResult.fromPromise((async () => {
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

export const with_return: typeof $asyncIterator.with_return = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  return_: Parameters<typeof $asyncIterator.with_return<T, TReturn, TNext>>[1],
) => {
  const newIterator: AsyncIterableIterator<T, TReturn, TNext> = {
    ...iterator,
    next: (...args) => iterator.next(...args),
    return: async (value?: TReturn) =>
      toIteratorResult(await return_(toOption(value))),
    [Symbol.asyncIterator]() {
      return this;
    },
  };
  return newIterator;
};

export const with_throw: typeof $asyncIterator.with_throw = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  throw_: Parameters<typeof $asyncIterator.with_throw<T, TReturn, TNext>>[1],
) => {
  const newIterator: AsyncIterableIterator<T, TReturn, TNext> = {
    ...iterator,
    next: (...args) => iterator.next(...args),
    throw: async (value?: unknown) => toIteratorResult(await throw_(value)),
    [Symbol.asyncIterator]() {
      return this;
    },
  };
  return newIterator;
};

export const next: typeof $asyncIterator.next = <T, TReturn, TNext>(
  iterator: AsyncIterator<T, TReturn, TNext>,
) => {
  return toResult.fromPromise(
    Promise.resolve(iterator.next()).then((result) =>
      toGleamIteratorResult(result)
    ),
  );
};

export const next_with: typeof $asyncIterator.next_with = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  value: Parameters<typeof $asyncIterator.next_with<T, TReturn, TNext>>[1],
) => {
  return toResult.fromPromise(
    Promise.resolve(iterator.next(value)).then((result) =>
      toGleamIteratorResult(result)
    ),
  );
};

export const return_: typeof $asyncIterator.return$ = <T, TReturn, TNext>(
  iterator: AsyncIterator<T, TReturn, TNext>,
) => {
  if (!iterator.return) {
    return Promise.resolve(
      toResult.fromThrows(() =>
        $iteratorHandlerOutcome.IteratorHandlerOutcome$NoHandler()
      ),
    );
  }
  return toResult.fromPromise(
    iterator.return().then((result) =>
      $iteratorHandlerOutcome.IteratorHandlerOutcome$Handled(
        toGleamIteratorResult(result),
      )
    ),
  );
};

export const return_with: typeof $asyncIterator.return_with = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  value: Parameters<typeof $asyncIterator.return_with<T, TReturn>>[1],
) => {
  if (!iterator.return) {
    return Promise.resolve(
      toResult.fromThrows(() =>
        $iteratorHandlerOutcome.IteratorHandlerOutcome$NoHandler()
      ),
    );
  }
  return toResult.fromPromise(
    iterator.return(value).then((result) =>
      $iteratorHandlerOutcome.IteratorHandlerOutcome$Handled(
        toGleamIteratorResult(result),
      )
    ),
  );
};

export const throw_: typeof $asyncIterator.throw$ = <T, TReturn, TNext>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  reason: Parameters<typeof $asyncIterator.throw$<T, TReturn>>[1],
) => {
  if (!iterator.throw) {
    return Promise.resolve(
      toResult.fromThrows(() =>
        $iteratorHandlerOutcome.IteratorHandlerOutcome$NoHandler()
      ),
    );
  }
  return toResult.fromPromise(
    iterator.throw($option.unwrap(reason, undefined)).then((result) =>
      $iteratorHandlerOutcome.IteratorHandlerOutcome$Handled(
        toGleamIteratorResult(result),
      )
    ),
  );
};

export const for_await: typeof $asyncIterator.for_await = <
  T,
  TReturn,
  TNext,
>(
  iterator: AsyncIterator<T, TReturn, TNext>,
  fun: Parameters<typeof $asyncIterator.for_await<T>>[1],
) => {
  return toResult.fromPromise((async () => {
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
