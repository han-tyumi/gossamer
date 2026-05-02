import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gossamer/event.{type Event}

/// Opaque handle to the underlying JS `CustomEvent`.
///
@external(javascript, "./custom_event_ref.type.ts", "CustomEventRef$")
@internal
pub type CustomEventRef

/// An `Event` with a custom `detail` payload that can be dispatched from
/// application code.
///
/// See [CustomEvent](https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent) on MDN.
///
pub type CustomEvent {
  CustomEvent(
    /// The detail payload, or `None` if none was provided.
    detail: Option(Dynamic),
    /// Internal handle to the underlying JS `CustomEvent`.
    ref: CustomEventRef,
  )
}

/// Creates a new `CustomEvent` with the given type.
///
@external(javascript, "./custom_event.ffi.mjs", "new_")
pub fn new(type_: String) -> CustomEvent

/// Creates a new `CustomEvent` with the given type and detail value.
///
@external(javascript, "./custom_event.ffi.mjs", "new_with_detail")
pub fn new_with_detail(type_: String, detail detail: a) -> CustomEvent

/// Converts a `CustomEvent` to a base `Event` for use with functions in
/// `gossamer/event`.
///
@external(javascript, "./custom_event.ffi.mjs", "to_event")
pub fn to_event(event: CustomEvent) -> Event
