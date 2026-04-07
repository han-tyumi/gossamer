import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option, None, Some}
import gossamer/promise_settled_result.{type PromiseSettledResult}

@external(javascript, "./promise.type.ts", "Promise$")
pub type Promise(a)

pub type PromiseWithResolvers(a) {
  PromiseWithResolvers(
    promise: Promise(a),
    resolve: fn(a) -> Nil,
    reject: fn(Dynamic) -> Nil,
  )
}

/// Creates a new Promise.
/// The executor callback is passed two arguments: a resolve callback used to
/// resolve the promise with a value, and a reject callback used to reject the
/// promise with a provided reason or error.
///
@external(javascript, "./promise.ffi.mjs", "new_")
pub fn new(executor: fn(fn(a) -> Nil, fn(r) -> Nil) -> Nil) -> Promise(a)

/// Creates a Promise that is resolved with a list of results when all of the
/// provided Promises resolve, or rejected when any Promise is rejected.
///
@external(javascript, "./promise.ffi.mjs", "all")
pub fn all(values: List(Promise(a))) -> Promise(List(a))

/// Creates a Promise that is resolved or rejected when any of the provided
/// Promises are resolved or rejected.
///
@external(javascript, "./promise.ffi.mjs", "race")
pub fn race(values: List(Promise(a))) -> Promise(a)

/// Creates a new rejected promise for the provided reason.
///
@external(javascript, "./promise.ffi.mjs", "reject")
pub fn reject(reason: r) -> Promise(a)

/// Creates a new resolved promise for the provided value.
///
@external(javascript, "./promise.ffi.mjs", "resolve")
pub fn resolve(value: a) -> Promise(a)

/// Creates a Promise that is resolved with a list of `PromiseSettledResult`s
/// when all of the provided Promises resolve or reject.
///
@external(javascript, "./promise.ffi.mjs", "all_settled")
pub fn all_settled(
  values: List(Promise(a)),
) -> Promise(List(PromiseSettledResult(a)))

/// Returns a promise that is fulfilled by the first given promise to be
/// fulfilled, or rejected with an AggregateError containing an array of
/// rejection reasons if all of the given promises are rejected.
///
@external(javascript, "./promise.ffi.mjs", "any")
pub fn any(values: List(Promise(a))) -> Promise(a)

/// Creates a new Promise and returns it in a `PromiseWithResolvers` record,
/// along with its resolve and reject functions.
///
@external(javascript, "./promise.ffi.mjs", "with_resolvers")
pub fn with_resolvers() -> PromiseWithResolvers(a)

/// Attaches a callback for the resolution of the Promise.
///
@external(javascript, "./promise.ffi.mjs", "then")
pub fn then(promise: Promise(a), onfulfilled: fn(a) -> b) -> Promise(b)

/// Attaches a callback for only the rejection of the Promise.
///
@external(javascript, "./promise.ffi.mjs", "catch_")
pub fn catch(promise: Promise(a), onrejected: fn(Dynamic) -> a) -> Promise(a)

/// Attaches a callback that is invoked when the Promise is settled
/// (fulfilled or rejected). The resolved value cannot be modified from the
/// callback.
///
@external(javascript, "./promise.ffi.mjs", "finally_")
pub fn finally(promise: Promise(a), onfinally: fn() -> Nil) -> Promise(a)

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
