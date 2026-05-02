//// Test helpers for runtime-conditional behavior. Detects which JS runtime
//// the tests are running on (Deno, Node, Bun) and gates test bodies on the
//// result. `catching` wraps an FFI panic in a `Result` so panic-asserting
//// tests can verify documented divergence on a specific runtime.

import gleam/list
import gossamer/js_error.{type JsError}

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

/// Returns `Error` if `thunk` throws.
///
@external(javascript, "./runtime.ffi.mjs", "catching")
pub fn catching(thunk: fn() -> a) -> Result(a, JsError)
