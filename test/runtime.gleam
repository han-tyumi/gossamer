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

/// Whether the host operating system is macOS. Some divergences are
/// runtime-and-OS-specific — Bun's JavaScriptCore links the system ICU
/// on macOS but bundles its own on Linux, so Intl output can differ by
/// OS for the same Bun version.
///
@external(javascript, "./runtime.ffi.mjs", "is_macos")
pub fn is_macos() -> Bool

/// Skips `body` when `condition` holds. Compose with `is_macos` and
/// `current` for divergences `skip_on`/`only_on` can't express.
///
pub fn skip_when(condition: Bool, body: fn() -> a) -> Nil {
  case condition {
    True -> Nil
    False -> {
      body()
      Nil
    }
  }
}

/// Runs `body` only when `condition` holds.
///
pub fn only_when(condition: Bool, body: fn() -> a) -> Nil {
  case condition {
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
