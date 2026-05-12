import gleam/dynamic.{type Dynamic}

/// One end of a `MessageChannel`, used to send and receive messages.
///
/// See [MessagePort](https://developer.mozilla.org/en-US/docs/Web/API/MessagePort) on MDN.
///
@external(javascript, "./message_port.type.ts", "MessagePort$")
pub type MessagePort

/// Sends `data` to the other end of the channel. Returns an error if
/// `data` can't be serialized by the structured-clone algorithm —
/// functions, symbols, and most class instances are not cloneable.
///
@external(javascript, "./message_port.ffi.mjs", "post_message")
pub fn post_message(to port: MessagePort, data data: a) -> Result(Nil, Nil)

@external(javascript, "./message_port.ffi.mjs", "start")
pub fn start(port: MessagePort) -> Nil

@external(javascript, "./message_port.ffi.mjs", "close")
pub fn close(port: MessagePort) -> Nil

/// Registers a handler invoked with each message's data payload. Decode the
/// payload with `gleam/dynamic/decode`.
///
@external(javascript, "./message_port.ffi.mjs", "on_message")
pub fn on_message(port: MessagePort, run handler: fn(Dynamic) -> a) -> Nil

/// Registers a handler invoked when an incoming message cannot be deserialized.
///
@external(javascript, "./message_port.ffi.mjs", "on_message_error")
pub fn on_message_error(port: MessagePort, run handler: fn() -> a) -> Nil
