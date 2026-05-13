import * as $iteration from "$/gossamer/gossamer/iteration.mjs";
import {
  type Option$,
  Option$isNone,
  Option$Some$0,
} from "$/gleam_stdlib/gleam/option.mjs";
import type * as $iterator from "$/gossamer/gossamer/iteration/iterator.mjs";
import { Result$Ok } from "$/prelude.mjs";
import {
  jsIteratorAsYielder,
  toCallbackResult,
  toGleamIteratorResult,
  toIteratorResult,
  yielderAsJsIterator,
} from "~/gossamer/iteration.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";

function optionToValue<T>(option: Option$<T>): T | undefined {
  return Option$isNone(option) ? undefined : Option$Some$0(option);
}

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

export const set_return: typeof $iterator.set_return = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  return_: Parameters<typeof $iterator.set_return<T, TReturn, TNext>>[1],
) => {
  const newIterator: IterableIterator<T, TReturn, TNext> = {
    ...iterator,
    next: (...args) => iterator.next(...args),
    return: (value?: TReturn) => toIteratorResult(return_(toOption(value))),
    [Symbol.iterator]() {
      return this;
    },
  };
  return newIterator;
};

export const set_throw: typeof $iterator.set_throw = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  throw_: Parameters<typeof $iterator.set_throw<T, TReturn, TNext>>[1],
) => {
  const newIterator: IterableIterator<T, TReturn, TNext> = {
    ...iterator,
    next: (...args) => iterator.next(...args),
    throw: (value?: unknown) => toIteratorResult(throw_(value)),
    [Symbol.iterator]() {
      return this;
    },
  };
  return newIterator;
};

export const next: typeof $iterator.next = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  value: Option$<TNext>,
) => {
  const sent = optionToValue(value);
  const result = sent === undefined ? iterator.next() : iterator.next(sent);
  return toGleamIteratorResult(result);
};

export const return_: typeof $iterator.return$ = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  value: Option$<TReturn>,
) => {
  const returnFn = iterator.return;
  if (!returnFn) {
    return Result$Ok(
      $iteration.IteratorHandlerOutcome$NoHandler(),
    );
  }
  const sent = optionToValue(value);
  return toCallbackResult(() =>
    $iteration.IteratorHandlerOutcome$Handled(
      toGleamIteratorResult(
        sent === undefined
          ? returnFn.call(iterator)
          : returnFn.call(iterator, sent),
      ),
    )
  );
};

export const throw_: typeof $iterator.throw$ = <T, TReturn, TNext>(
  iterator: Iterator<T, TReturn, TNext>,
  reason: Parameters<typeof $iterator.throw$<T, TReturn>>[1],
) => {
  const throwFn = iterator.throw;
  if (!throwFn) {
    return Result$Ok(
      $iteration.IteratorHandlerOutcome$NoHandler(),
    );
  }
  return toCallbackResult(() =>
    $iteration.IteratorHandlerOutcome$Handled(
      toGleamIteratorResult(throwFn.call(iterator, reason)),
    )
  );
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
