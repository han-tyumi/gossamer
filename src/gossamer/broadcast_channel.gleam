//// A named channel that broadcasts messages to every other
//// `BroadcastChannel` of the same name in the same agent — workers
//// on the same origin, same-origin browser tabs and iframes.
//// Construct one with [`new`](#new), send with
//// [`post_message`](#post_message), and react to incoming messages
//// via [`set_on_message`](#set_on_message).

import gleam/dynamic.{type Dynamic}

/// A named broadcast channel shared across same-origin contexts.
///
/// See [BroadcastChannel](https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel) on MDN.
///
@external(javascript, "./broadcast_channel.type.ts", "BroadcastChannel$")
pub type BroadcastChannel

/// Reasons a [`post_message`](#post_message) call can fail.
///
pub type PostMessageError {
  /// `data` can't be serialized by the structured-clone algorithm —
  /// functions, symbols, and most class instances aren't cloneable.
  DataClone

  /// The channel has been [`close`d](#close).
  InvalidState
}

/// Creates a `BroadcastChannel` for the given name. Any other channel
/// of the same name in the same agent will receive messages posted
/// here.
///
@external(javascript, "./broadcast_channel.ffi.mjs", "new_")
pub fn new(name: String) -> BroadcastChannel

/// The name the channel was constructed with.
///
@external(javascript, "./broadcast_channel.ffi.mjs", "name")
pub fn name(channel: BroadcastChannel) -> String

/// Sends `data` to every other `BroadcastChannel` of the same name.
/// Returns [`DataClone`](#PostMessageError) if `data` can't be
/// serialized by the structured-clone algorithm, or
/// [`InvalidState`](#PostMessageError) if the channel has been
/// [`close`d](#close).
///
@external(javascript, "./broadcast_channel.ffi.mjs", "post_message")
pub fn post_message(
  to channel: BroadcastChannel,
  data data: a,
) -> Result(Nil, PostMessageError)

/// Closes the channel. Messages posted to other channels of the same
/// name no longer arrive here.
///
@external(javascript, "./broadcast_channel.ffi.mjs", "close")
pub fn close(channel: BroadcastChannel) -> Nil

/// Registers a handler invoked with each broadcast message's data
/// payload. The handler also receives the
/// [`BroadcastChannel`](#BroadcastChannel) so it can reply via
/// [`post_message`](#post_message) from inside. Decode the payload
/// with `gleam/dynamic/decode`. `ArrayBuffer` payloads are exposed as
/// `BitArray`; other values pass through unchanged. Equivalent to
/// JavaScript's `channel.onmessage`.
///
@external(javascript, "./broadcast_channel.ffi.mjs", "set_on_message")
pub fn set_on_message(
  channel: BroadcastChannel,
  run handler: fn(Dynamic, BroadcastChannel) -> a,
) -> Nil
