import gossamer/event.{type Event}
import gossamer/event_target/listener_option.{type ListenerOption}

@external(javascript, "./event_target.type.ts", "EventTarget$")
pub type EventTarget

/// Creates a new `EventTarget`.
///
@external(javascript, "./event_target.ffi.mjs", "new_")
pub fn new() -> EventTarget

/// Registers an event listener on the target for the given event type.
///
@external(javascript, "./event_target.ffi.mjs", "add_event_listener")
pub fn add_event_listener(
  to target: EventTarget,
  on type_: String,
  run listener: fn(Event) -> a,
) -> Nil

/// Registers an event listener on the target with additional options such as
/// `Once`, `Capture`, `Passive`, or `Signal`.
///
@external(javascript, "./event_target.ffi.mjs", "add_event_listener_with")
pub fn add_event_listener_with(
  to target: EventTarget,
  on type_: String,
  run listener: fn(Event) -> a,
  with options: List(ListenerOption),
) -> Nil

/// Removes a previously registered event listener from the target. The
/// listener must be the same function reference that was passed to
/// `add_event_listener`.
///
@external(javascript, "./event_target.ffi.mjs", "remove_event_listener")
pub fn remove_event_listener(
  from target: EventTarget,
  on type_: String,
  listener listener: fn(Event) -> a,
) -> Nil

/// Removes a previously registered event listener with the matching options.
///
@external(javascript, "./event_target.ffi.mjs", "remove_event_listener_with")
pub fn remove_event_listener_with(
  from target: EventTarget,
  on type_: String,
  listener listener: fn(Event) -> a,
  with options: List(ListenerOption),
) -> Nil

/// Dispatches an event to the target, invoking any registered listeners.
/// Returns whether `prevent_default` was not called by any listener.
///
@external(javascript, "./event_target.ffi.mjs", "dispatch_event")
pub fn dispatch_event(on target: EventTarget, event event: Event) -> Bool
