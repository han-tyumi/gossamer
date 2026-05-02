import gleam/dynamic.{type Dynamic}

/// An event received from a message channel, port, worker, or WebSocket.
///
/// See [MessageEvent](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent) on MDN.
///
@external(javascript, "./message_event.type.ts", "MessageEvent$")
pub type MessageEvent

pub type Fields {
  Fields(data: Dynamic, origin: String, last_event_id: String)
}

@external(javascript, "./message_event.ffi.mjs", "to_fields")
pub fn to_fields(event: MessageEvent) -> Fields

@external(javascript, "./message_event.ffi.mjs", "data")
pub fn data(event: MessageEvent) -> Dynamic

@external(javascript, "./message_event.ffi.mjs", "origin")
pub fn origin(event: MessageEvent) -> String

@external(javascript, "./message_event.ffi.mjs", "last_event_id")
pub fn last_event_id(event: MessageEvent) -> String
