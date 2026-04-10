import gleam/dynamic.{type Dynamic}
import gossamer/event.{type Event}

@external(javascript, "./custom_event.type.ts", "CustomEvent$")
pub type CustomEvent

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
