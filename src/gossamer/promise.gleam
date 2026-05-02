import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option, None, Some}
import gossamer/js_error.{type JsError}

/// A proxy for a value that may not be known when the promise is created.
///
/// See [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) on MDN.
///
@external(javascript, "./promise.type.ts", "Promise$")
pub type Promise(a)

pub type PromiseSettledResult(a) {
  Fulfilled(value: a)
  Rejected(reason: Dynamic)
}

pub type PromiseWithResolvers(a, r) {
  PromiseWithResolvers(
    promise: Promise(Result(a, JsError)),
    resolve: fn(a) -> Nil,
    reject: fn(r) -> Nil,
  )
}

/// Creates a new `Promise` by running `executor`. `executor` receives
/// `resolve` and `reject` callbacks; calling `resolve` fulfills the promise,
/// calling `reject` (or throwing) rejects it.
///
@external(javascript, "./promise.ffi.mjs", "new_")
pub fn new(
  executor: fn(fn(a) -> b, fn(r) -> c) -> d,
) -> Promise(Result(a, JsError))

/// Resolves with a list of the fulfilled values when all provided promises
/// fulfill, or rejects as soon as any promise rejects.
///
@external(javascript, "./promise.ffi.mjs", "all")
pub fn all(values: List(Promise(a))) -> Promise(Result(List(a), JsError))

/// Resolves or rejects as soon as any of the provided promises resolves or
/// rejects, taking on that promise's value.
///
@external(javascript, "./promise.ffi.mjs", "race")
pub fn race(values: List(Promise(a))) -> Promise(Result(a, JsError))

/// Creates a promise already rejected with `reason`.
///
@external(javascript, "./promise.ffi.mjs", "reject")
pub fn reject(reason: r) -> Promise(a)

/// Creates a promise already fulfilled with `value`.
///
@external(javascript, "./promise.ffi.mjs", "resolve")
pub fn resolve(value: a) -> Promise(a)

/// Resolves with a list of `PromiseSettledResult`s when all provided promises
/// have settled (resolved or rejected), never short-circuiting on rejection.
///
@external(javascript, "./promise.ffi.mjs", "all_settled")
pub fn all_settled(
  values: List(Promise(a)),
) -> Promise(List(PromiseSettledResult(a)))

/// Resolves with the first fulfilled promise's value. Rejects only if all
/// provided promises reject.
///
@external(javascript, "./promise.ffi.mjs", "any")
pub fn any(values: List(Promise(a))) -> Promise(Result(a, JsError))

/// Runs `func` and wraps the result in a promise. The returned promise
/// resolves with the function's return value or rejects if it throws or
/// returns a rejecting promise.
///
@external(javascript, "./promise.ffi.mjs", "try_")
pub fn try(func: fn() -> a) -> Promise(Result(a, JsError))

/// Creates a promise along with `resolve` and `reject` callbacks that can
/// settle it from outside. Useful when the settling logic isn't known at
/// construction time.
///
@external(javascript, "./promise.ffi.mjs", "with_resolvers")
pub fn with_resolvers() -> PromiseWithResolvers(a, r)

/// Chains `onfulfilled` to run after `promise` fulfills. The returned
/// promise resolves with the callback's return value.
///
@external(javascript, "./promise.ffi.mjs", "then")
pub fn then(promise: Promise(a), apply onfulfilled: fn(a) -> b) -> Promise(b)

/// Chains `onrejected` to run if `promise` rejects. The returned promise
/// resolves with the callback's return value.
///
@external(javascript, "./promise.ffi.mjs", "catch_")
pub fn catch(
  promise: Promise(a),
  apply onrejected: fn(Dynamic) -> a,
) -> Promise(a)

/// Chains `onfinally` to run after `promise` settles (either fulfills or
/// rejects), without affecting the resolved value.
///
@external(javascript, "./promise.ffi.mjs", "finally_")
pub fn finally(promise: Promise(a), run onfinally: fn() -> b) -> Promise(a)

/// Converts a `Result` into a promise. `Ok` becomes resolved; `Error`
/// becomes rejected.
///
pub fn from_result(result: Result(a, _)) -> Promise(a) {
  case result {
    Ok(value) -> resolve(value)
    Error(error) -> reject(error)
  }
}

/// Converts an `Option` into a promise. `Some` becomes resolved; `None`
/// becomes rejected with `Nil`.
///
pub fn from_option(option: Option(a)) -> Promise(a) {
  case option {
    Some(value) -> resolve(value)
    None -> reject(Nil)
  }
}
