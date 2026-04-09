import gleam/dynamic.{type Dynamic}
import gossamer/event_init.{type EventInit}
import gossamer/event_phase.{type EventPhase}

@external(javascript, "./event.type.ts", "Event$")
pub type Event

/// Creates a new `Event` with the given type.
///
@external(javascript, "./event.ffi.mjs", "new_")
pub fn new(type_: String) -> Event

/// Creates a new `Event` with the given type and initialization options.
///
@external(javascript, "./event.ffi.mjs", "new_with")
pub fn new_with(type_: String, with init: List(EventInit)) -> Event

/// Returns the type of the event (e.g., "click", "load").
///
@external(javascript, "./event.ffi.mjs", "type_")
pub fn type_(of event: Event) -> String

/// Returns the event target that dispatched the event, or an error if the
/// event has not been dispatched.
///
@external(javascript, "./event.ffi.mjs", "target")
pub fn target(of event: Event) -> Result(Dynamic, Nil)

/// Returns the event target whose event listener is currently being invoked,
/// or an error if none.
///
@external(javascript, "./event.ffi.mjs", "current_target")
pub fn current_target(of event: Event) -> Result(Dynamic, Nil)

/// Returns the current phase of the event flow.
///
@external(javascript, "./event.ffi.mjs", "event_phase")
pub fn event_phase(of event: Event) -> EventPhase

/// Returns the time at which the event was created, in milliseconds since the
/// time origin.
///
@external(javascript, "./event.ffi.mjs", "time_stamp")
pub fn time_stamp(of event: Event) -> Float

/// Returns whether the event bubbles up through the DOM tree.
///
@external(javascript, "./event.ffi.mjs", "is_bubbles")
pub fn is_bubbles(of event: Event) -> Bool

/// Returns whether the event can be cancelled.
///
@external(javascript, "./event.ffi.mjs", "is_cancelable")
pub fn is_cancelable(of event: Event) -> Bool

/// Returns whether `prevent_default` has been called on the event.
///
@external(javascript, "./event.ffi.mjs", "is_default_prevented")
pub fn is_default_prevented(of event: Event) -> Bool

/// Returns whether the event is composed and will propagate across shadow DOM
/// boundaries.
///
@external(javascript, "./event.ffi.mjs", "is_composed")
pub fn is_composed(of event: Event) -> Bool

/// Returns whether the event was dispatched by the user agent rather than by
/// script.
///
@external(javascript, "./event.ffi.mjs", "is_trusted")
pub fn is_trusted(of event: Event) -> Bool

/// Cancels the event if it is cancelable, preventing the default action that
/// belongs to the event from occurring.
///
@external(javascript, "./event.ffi.mjs", "prevent_default")
pub fn prevent_default(event: Event) -> Event

/// Prevents further propagation of the current event in the capturing and
/// bubbling phases.
///
@external(javascript, "./event.ffi.mjs", "stop_propagation")
pub fn stop_propagation(event: Event) -> Event

/// Prevents all other event listeners from being called, including those on
/// the same target.
///
@external(javascript, "./event.ffi.mjs", "stop_immediate_propagation")
pub fn stop_immediate_propagation(event: Event) -> Event

/// Returns the event's path, which is a list of event targets through which
/// the event will pass.
///
@external(javascript, "./event.ffi.mjs", "composed_path")
pub fn composed_path(of event: Event) -> List(Dynamic)
