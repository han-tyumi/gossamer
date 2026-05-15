//// An error event surfaced when a script throws an uncaught error.
//// Inspect the event with [`info`](#info) to read the message,
//// location, and thrown value.

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}

/// An event delivered when a script throws an uncaught error.
///
/// See [ErrorEvent](https://developer.mozilla.org/en-US/docs/Web/API/ErrorEvent) on MDN.
///
@external(javascript, "./error_event.type.ts", "ErrorEvent$")
pub type ErrorEvent

/// A snapshot of an [`ErrorEvent`](#ErrorEvent)'s fields, returned by
/// [`info`](#info). All fields are immutable once the event has been
/// dispatched.
///
pub type Info {
  Info(
    /// A human-readable description of the error.
    message: String,
    /// The URL of the script in which the error occurred. Empty when
    /// unavailable.
    filename: String,
    /// The line number in the script. Zero when unavailable.
    lineno: Int,
    /// The column number in the script. Zero when unavailable.
    colno: Int,
    /// The thrown value, or `None` if the source didn't include one.
    /// Usually a JavaScript `Error` instance; decode with
    /// `gleam/dynamic/decode` if needed.
    error: Option(Dynamic),
  )
}

/// A snapshot of the event's message, location, and thrown value.
///
@external(javascript, "./error_event.ffi.mjs", "info")
pub fn info(event: ErrorEvent) -> Info
