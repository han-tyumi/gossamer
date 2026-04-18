import * as $promise from "$/gossamer/gossamer/promise.mjs";
import { fromArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

export type Promise$<T> = Promise<T>;

export const new_: typeof $promise.new$ = (executor) => {
  return toResult.fromPromise(
    new Promise((resolve, reject) => {
      executor(
        (value) => {
          resolve(value);
        },
        (reason) => {
          reject(reason);
        },
      );
    }),
  );
};

export const all: typeof $promise.all = (values) => {
  return toResult.fromPromise(
    Promise.all(values).then((results) => fromArray(results)),
  );
};

export const race: typeof $promise.race = (values) => {
  return toResult.fromPromise(Promise.race(values));
};

export const reject: typeof $promise.reject = (reason) => {
  return Promise.reject(reason);
};

export const resolve: typeof $promise.resolve = (value) => {
  return Promise.resolve(value);
};

export const all_settled: typeof $promise.all_settled = async (values) => {
  const results = await Promise.allSettled(values);
  return fromArray(
    results.map((result) =>
      result.status === "fulfilled"
        ? $promise.PromiseSettledResult$Fulfilled(result.value)
        : $promise.PromiseSettledResult$Rejected(result.reason)
    ),
  );
};

export const any: typeof $promise.any = (values) => {
  return toResult.fromPromise(Promise.any(values));
};

export const try_: typeof $promise.try$ = (func) => {
  return toResult.fromPromise(Promise.try(func));
};

export const with_resolvers: typeof $promise.with_resolvers = () => {
  const { promise, resolve, reject } = Promise.withResolvers();
  return $promise.PromiseWithResolvers$PromiseWithResolvers(
    toResult.fromPromise(promise),
    (value) => {
      resolve(value);
    },
    (reason) => {
      reject(reason);
    },
  );
};

export const then: typeof $promise.then$ = (promise, onfulfilled) => {
  return promise.then(onfulfilled);
};

export const catch_: typeof $promise.catch$ = (promise, onrejected) => {
  return promise.catch(onrejected);
};

export const finally_: typeof $promise.finally$ = (promise, onfinally) => {
  return promise.finally(onfinally);
};
