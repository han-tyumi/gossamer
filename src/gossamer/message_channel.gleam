//// A pair of [`MessagePort`s](./message_port.html#MessagePort)
//// connected as a bidirectional channel. Hand each port to a
//// different consumer; messages sent on either port arrive on the
//// other.
////
//// See [MessageChannel](https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel) on MDN.

import gossamer/message_port.{type MessagePort}

/// Creates a new pair of freshly-connected `MessagePort`s. Messages
/// sent on the first port are received on the second, and vice versa.
///
@external(javascript, "./message_channel.ffi.mjs", "new_")
pub fn new() -> #(MessagePort, MessagePort)
