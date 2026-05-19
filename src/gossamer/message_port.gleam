//// One end of a `MessageChannel`. Obtain ports via
//// [`message_channel.port1`](./message_channel.html#port1) or
//// [`port2`](./message_channel.html#port2), send messages with
//// [`post_message`](#post_message), and react to incoming messages
//// via [`set_on_message`](#set_on_message).

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

/// Disconnects the port. Subsequent messages sent on the paired port
/// are discarded.
///
@external(javascript, "./message_port.ffi.mjs", "close")
pub fn close(port: MessagePort) -> Nil

/// Registers a handler invoked with each message's data payload. The
/// handler also receives the [`MessagePort`](#MessagePort) so it can
/// reply via [`post_message`](#post_message) from inside. Decode the
/// payload with `gleam/dynamic/decode`. `ArrayBuffer` payloads are
/// exposed as `BitArray`; other values pass through unchanged.
/// Equivalent to JavaScript's `port.onmessage`.
///
@external(javascript, "./message_port.ffi.mjs", "set_on_message")
pub fn set_on_message(
  port: MessagePort,
  run handler: fn(Dynamic, MessagePort) -> a,
) -> Nil
