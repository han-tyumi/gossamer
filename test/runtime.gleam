//// Test helpers for runtime-conditional behavior. Detects which JS runtime
//// the tests are running on (Deno, Node, Bun) and gates test bodies on the
//// result.

import gleam/list

pub type Runtime {
  Deno
  Node
  Bun
}

@external(javascript, "./runtime.ffi.mjs", "current")
pub fn current() -> Runtime

pub fn skip_on(runtime: Runtime, body: fn() -> a) -> Nil {
  case current() == runtime {
    True -> Nil
    False -> {
      body()
      Nil
    }
  }
}

pub fn skip_on_any(runtimes: List(Runtime), body: fn() -> a) -> Nil {
  case list.contains(runtimes, current()) {
    True -> Nil
    False -> {
      body()
      Nil
    }
  }
}

pub fn only_on(runtime: Runtime, body: fn() -> a) -> Nil {
  case current() == runtime {
    True -> {
      body()
      Nil
    }
    False -> Nil
  }
}

/// Runs `thunk` and catches any thrown error, returning its message as
/// `Error(message)`. Use to assert diagnostic-throw behavior at FFI
/// boundaries (e.g., `ensureMethod` runtime gaps).
///
@external(javascript, "./runtime.ffi.mjs", "catch_panic")
pub fn catch_panic(thunk: fn() -> a) -> Result(a, String)
