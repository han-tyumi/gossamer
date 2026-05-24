//// One end of a `MessageChannel`. Obtain a pair of ports via
//// [`message_channel.new`](./message_channel.html#new), send messages
//// with [`post_message`](#post_message), and react to incoming
//// messages via [`set_on_message`](#set_on_message).
////
//// ## Sending Gleam values
////
//// Every value passed to [`post_message`](#post_message) is serialized
//// by the structured-clone algorithm and arrives on the receiving side
//// as `Dynamic`. Decode it with `gleam/dynamic/decode`. Primitives,
//// tuples, and the fields of records cross intact. A record's
//// constructor type does not — decode the data field by field rather
//// than expect to pattern-match the original variant. Gleam lists and
//// dicts don't round-trip with their normal decoders; send a tuple or
//// a `gleam/javascript/array.Array` for sequences. Functions and
//// symbols can't be serialized; sending one returns `Error(Nil)`.
////
//// ## Transferring ports
////
//// A `MessagePort` inside the data passed to
//// [`post_message`](#post_message) is automatically detached on this
//// side and re-attached on the receiver — the message and any ports
//// reachable from it ride a single atomic call. Once a port has been
//// sent it is no longer usable on the sender; calling
//// [`post_message`](#post_message), [`close`](#close), or
//// [`set_on_message`](#set_on_message) on the transferred port is a
//// silent no-op. To extract a transferred port from received `Dynamic`
//// data, use [`from_dynamic`](#from_dynamic).

import gleam/dynamic.{type Dynamic}

/// One end of a `MessageChannel`, used to send and receive messages.
///
/// See [MessagePort](https://developer.mozilla.org/en-US/docs/Web/API/MessagePort) on MDN.
///
@external(javascript, "./message_port.type.ts", "MessagePort$")
pub type MessagePort

/// Sends `data` to the other end of the channel. Any `MessagePort`
/// reachable from `data` is detached on this side and arrives on the
/// receiving side at its position in the data structure. Returns an
/// error if `data` can't be serialized by the structured-clone
/// algorithm — functions, symbols, and most class instances are not
/// cloneable.
///
@external(javascript, "./message_port.ffi.mjs", "post_message")
pub fn post_message(port: MessagePort, data: a) -> Result(Nil, Nil)

/// Disconnects the port. Subsequent messages sent on the paired port
/// are discarded.
///
@external(javascript, "./message_port.ffi.mjs", "close")
pub fn close(port: MessagePort) -> Nil

/// Registers a handler invoked with each message's data payload. The
/// handler also receives the [`MessagePort`](#MessagePort) so it can
/// reply via [`post_message`](#post_message) from inside. Decode the
/// payload with `gleam/dynamic/decode`; extract any transferred ports
/// with [`from_dynamic`](#from_dynamic). `ArrayBuffer` payloads are
/// exposed as `BitArray`; other values pass through unchanged.
///
@external(javascript, "./message_port.ffi.mjs", "set_on_message")
pub fn set_on_message(
  port: MessagePort,
  run handler: fn(Dynamic, MessagePort) -> a,
) -> Nil

/// Projects a `Dynamic` value to a [`MessagePort`](#MessagePort).
/// Returns an error if the value is not a port. Compose with
/// `decode.dynamic` to extract a port from a specific field of a
/// received message.
///
@external(javascript, "./message_port.ffi.mjs", "from_dynamic")
pub fn from_dynamic(value: Dynamic) -> Result(MessagePort, Nil)
