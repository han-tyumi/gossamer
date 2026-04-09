import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option, None, Some}
import gossamer/promise_settled_result.{type PromiseSettledResult}

@external(javascript, "./promise.type.ts", "Promise$")
pub type Promise(a)

pub type PromiseWithResolvers(a, r) {
  PromiseWithResolvers(
    promise: Promise(a),
    resolve: fn(a) -> Nil,
    reject: fn(r) -> Nil,
  )
}

@external(javascript, "./promise.ffi.mjs", "new_")
pub fn new(executor: fn(fn(a) -> b, fn(r) -> c) -> d) -> Promise(a)

/// Resolves with a list of results when all provided promises resolve, or
/// rejects when any promise is rejected.
///
@external(javascript, "./promise.ffi.mjs", "all")
pub fn all(values: List(Promise(a))) -> Promise(List(a))

/// Resolves or rejects as soon as any of the provided promises resolves or
/// rejects, taking on that promise's value.
///
@external(javascript, "./promise.ffi.mjs", "race")
pub fn race(values: List(Promise(a))) -> Promise(a)

@external(javascript, "./promise.ffi.mjs", "reject")
pub fn reject(reason: r) -> Promise(a)

@external(javascript, "./promise.ffi.mjs", "resolve")
pub fn resolve(value: a) -> Promise(a)

/// Resolves with a list of `PromiseSettledResult`s when all provided promises
/// have settled (resolved or rejected), never short-circuiting on rejection.
///
@external(javascript, "./promise.ffi.mjs", "all_settled")
pub fn all_settled(
  values: List(Promise(a)),
) -> Promise(List(PromiseSettledResult(a)))

/// Resolves with the first fulfilled promise's value. Rejects with an
/// AggregateError only if all provided promises are rejected.
///
@external(javascript, "./promise.ffi.mjs", "any")
pub fn any(values: List(Promise(a))) -> Promise(a)

@external(javascript, "./promise.ffi.mjs", "try_")
pub fn try(func: fn() -> a) -> Promise(Result(a, String))

@external(javascript, "./promise.ffi.mjs", "with_resolvers")
pub fn with_resolvers() -> PromiseWithResolvers(a, r)

@external(javascript, "./promise.ffi.mjs", "then")
pub fn then(promise: Promise(a), apply onfulfilled: fn(a) -> b) -> Promise(b)

@external(javascript, "./promise.ffi.mjs", "catch_")
pub fn catch(
  promise: Promise(a),
  apply onrejected: fn(Dynamic) -> a,
) -> Promise(a)

@external(javascript, "./promise.ffi.mjs", "finally_")
pub fn finally(promise: Promise(a), run onfinally: fn() -> b) -> Promise(a)

pub fn from_result(result: Result(a, _)) -> Promise(a) {
  case result {
    Ok(value) -> resolve(value)
    Error(error) -> reject(error)
  }
}

pub fn from_option(option: Option(a)) -> Promise(a) {
  case option {
    Some(value) -> resolve(value)
    None -> reject(Nil)
  }
}
