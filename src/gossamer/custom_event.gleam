import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gossamer/event.{type Event}

/// An `Event` with a custom `detail` payload that can be dispatched from
/// application code.
///
/// See [CustomEvent](https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent) on MDN.
///
@external(javascript, "./custom_event.type.ts", "CustomEvent$")
pub type CustomEvent

/// The data carried by a `CustomEvent`. Inherited `Event` properties
/// (`type`, `bubbles`, `cancelable`, etc.) are reachable via `to_event`
/// and the functions in `gossamer/event`.
///
pub type Fields {
  Fields(
    /// The detail payload, or `None` if none was provided.
    detail: Option(Dynamic),
  )
}

@external(javascript, "./custom_event.ffi.mjs", "to_fields")
pub fn to_fields(event: CustomEvent) -> Fields

/// Creates a new `CustomEvent` with the given type.
///
@external(javascript, "./custom_event.ffi.mjs", "new_")
pub fn new(type_: String) -> CustomEvent

/// Creates a new `CustomEvent` with the given type and detail value.
///
@external(javascript, "./custom_event.ffi.mjs", "new_with_detail")
pub fn new_with_detail(type_: String, detail detail: a) -> CustomEvent

/// Returns the detail value associated with the event, or an error if none
/// was provided.
///
@external(javascript, "./custom_event.ffi.mjs", "detail")
pub fn detail(of event: CustomEvent) -> Result(Dynamic, Nil)

/// Converts a `CustomEvent` to a base `Event` for use with functions in
/// `gossamer/event`.
///
@external(javascript, "./custom_event.ffi.mjs", "to_event")
pub fn to_event(event: CustomEvent) -> Event
