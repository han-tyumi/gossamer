import gleam/dynamic.{type Dynamic}

/// Opaque handle to the underlying JS `MessageEvent`.
///
@external(javascript, "./message_event_ref.type.ts", "MessageEventRef$")
@internal
pub type MessageEventRef

/// An event received from a message channel, port, worker, or WebSocket.
///
/// See [MessageEvent](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent) on MDN.
///
pub type MessageEvent {
  MessageEvent(
    data: Dynamic,
    origin: String,
    last_event_id: String,
    /// Internal handle to the underlying JS `MessageEvent`.
    ref: MessageEventRef,
  )
}
