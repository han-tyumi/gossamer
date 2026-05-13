//// The event delivered to `on_message` handlers across message
//// channels, message ports, workers, and WebSockets. Read the
//// payload via [`data`](#data) and origin metadata via
//// [`origin`](#origin) / [`last_event_id`](#last_event_id).

import gleam/dynamic.{type Dynamic}

/// An event received from a message channel, port, worker, or WebSocket.
///
/// See [MessageEvent](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent) on MDN.
///
@external(javascript, "./message_event.type.ts", "MessageEvent$")
pub type MessageEvent

/// The event's data payload. `ArrayBuffer` values are exposed as
/// `BitArray`; decode with `gleam/dynamic/decode.bit_array`. Other
/// values pass through unchanged.
///
@external(javascript, "./message_event.ffi.mjs", "data")
pub fn data(event: MessageEvent) -> Dynamic

/// The origin of the sender, populated for cross-document messages
/// and server-sent events. Empty for `MessageChannel` and
/// `MessagePort` events.
///
@external(javascript, "./message_event.ffi.mjs", "origin")
pub fn origin(event: MessageEvent) -> String

/// The event id from the last server-sent event. Empty for
/// non-server-sent events.
///
@external(javascript, "./message_event.ffi.mjs", "last_event_id")
pub fn last_event_id(event: MessageEvent) -> String
