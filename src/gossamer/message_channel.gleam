//// A pair of `MessagePort`s connected as a bidirectional channel.
//// Create one and hand each port to a different consumer; messages
//// sent on one port arrive on the other.

import gossamer/message_port.{type MessagePort}

/// A bidirectional communication channel with two `MessagePort`s.
/// Messages sent on one port are received on the other.
///
/// See [MessageChannel](https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel) on MDN.
///
@external(javascript, "./message_channel.type.ts", "MessageChannel$")
pub type MessageChannel

/// Creates a new `MessageChannel` with two freshly-connected ports.
///
@external(javascript, "./message_channel.ffi.mjs", "new_")
pub fn new() -> MessageChannel

/// The first port of the channel. Messages sent here are received on
/// [`port2`](#port2).
///
@external(javascript, "./message_channel.ffi.mjs", "port1")
pub fn port1(channel: MessageChannel) -> MessagePort

/// The second port of the channel. Messages sent here are received on
/// [`port1`](#port1).
///
@external(javascript, "./message_channel.ffi.mjs", "port2")
pub fn port2(channel: MessageChannel) -> MessagePort
