import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gossamer/event.{type Event}

/// An `Event` reporting an error during script execution or resource
/// loading. Dispatched on `EventTarget`s for the `"error"` event type.
///
/// See [ErrorEvent](https://developer.mozilla.org/en-US/docs/Web/API/ErrorEvent) on MDN.
///
@external(javascript, "./error_event.type.ts", "ErrorEvent$")
pub type ErrorEvent

/// The data carried by an `ErrorEvent`. Inherited `Event` properties
/// (`type`, `bubbles`, `cancelable`, etc.) are reachable via `to_event`
/// and the functions in `gossamer/event`.
///
pub type Fields {
  Fields(
    message: String,
    filename: String,
    lineno: Int,
    colno: Int,
    error: Option(Dynamic),
  )
}

pub type ErrorEventInit(a) {
  Bubbles(Bool)
  Cancelable(Bool)
  Composed(Bool)
  Message(String)
  Filename(String)
  Lineno(Int)
  Colno(Int)
  Value(a)
}

@external(javascript, "./error_event.ffi.mjs", "to_fields")
pub fn to_fields(event: ErrorEvent) -> Fields

/// Creates a new `ErrorEvent` with the given type.
///
@external(javascript, "./error_event.ffi.mjs", "new_")
pub fn new(type_: String) -> ErrorEvent

/// Creates a new `ErrorEvent` with the given type and initialization
/// options.
///
@external(javascript, "./error_event.ffi.mjs", "new_with")
pub fn new_with(type_: String, with init: List(ErrorEventInit(a))) -> ErrorEvent

@external(javascript, "./error_event.ffi.mjs", "message")
pub fn message(of event: ErrorEvent) -> String

@external(javascript, "./error_event.ffi.mjs", "filename")
pub fn filename(of event: ErrorEvent) -> String

@external(javascript, "./error_event.ffi.mjs", "lineno")
pub fn lineno(of event: ErrorEvent) -> Int

@external(javascript, "./error_event.ffi.mjs", "colno")
pub fn colno(of event: ErrorEvent) -> Int

/// Returns the error value associated with the event, or an error if
/// none was provided.
///
@external(javascript, "./error_event.ffi.mjs", "error")
pub fn error(of event: ErrorEvent) -> Result(Dynamic, Nil)

/// Converts an `ErrorEvent` to a base `Event` for use with functions in
/// `gossamer/event`.
///
@external(javascript, "./error_event.ffi.mjs", "to_event")
pub fn to_event(event: ErrorEvent) -> Event
