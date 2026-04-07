import gleam/dynamic.{type Dynamic}

@external(javascript, "./message_event.type.ts", "MessageEvent$")
pub type MessageEvent

/// Returns the data of the message.
///
@external(javascript, "./message_event.ffi.mjs", "data")
pub fn data(event: MessageEvent) -> Dynamic

/// Returns the origin of the message, for server-sent events.
///
@external(javascript, "./message_event.ffi.mjs", "origin")
pub fn origin(event: MessageEvent) -> String

/// Returns the last event ID string, for server-sent events.
///
@external(javascript, "./message_event.ffi.mjs", "last_event_id")
pub fn last_event_id(event: MessageEvent) -> String
