//// Bidirectional, message-oriented WebSocket connections (`ws:` and
//// `wss:`). Construct via [`from_uri`](#from_uri); lifecycle events
//// arrive on the [`WebSocketEvent`](#WebSocketEvent) sum, dispatched
//// by the handler registered via [`with_on_event`](#with_on_event).

import gleam/option.{type Option, None, Some}
import gleam/uri.{type Uri}
import gossamer/blob.{type Blob}

/// Errors raised by `WebSocket` operations.
pub type WebSocketError {
  /// The URL is not an absolute `ws:` or `wss:` URL, or includes a
  /// fragment.
  InvalidUrl

  /// The protocols list contains duplicates or values that aren't valid
  /// HTTP header field tokens (per RFC 7230).
  InvalidProtocols

  /// The close code is not `1000` and not in the range `3000`–`4999`.
  InvalidCloseCode(code: Int)

  /// The close reason exceeds `123` bytes when encoded as UTF-8.
  CloseReasonTooLong

  /// A `send_*` call was made while the socket is in the `Connecting`
  /// state. Data sent on `Closing` or `Closed` sockets is silently
  /// discarded per spec and does not produce this error.
  NotOpen
}

// TODO: Happy-path coverage for `send_*` and listener delivery requires a
// live WebSocket server, which can't be created cross-runtime from pure
// Gleam. Tests currently cover the constructors, `ready_state`, `close`,
// `close_with`, and the `send_*` error path on a Connecting socket.

/// The data carried by a WebSocket close event.
///
pub type CloseEvent {
  CloseEvent(code: Int, reason: String, clean: Bool)
}

/// An event delivered to the handler registered via
/// [`with_on_event`](#with_on_event).
///
pub type WebSocketEvent {
  /// The connection was established and is ready to send and receive.
  Opened

  /// A text message arrived from the server.
  Text(String)

  /// A binary message arrived from the server.
  Binary(BitArray)

  /// A transport-level failure occurred. The WebSocket `error` event
  /// carries no usable payload per spec.
  Errored

  /// The connection closed. The event carries the close code, the
  /// reason string, and whether the close was clean.
  Disconnected(event: CloseEvent)
}

/// The state of a `WebSocket` connection.
///
pub type ReadyState {
  /// The handshake is in progress.
  Connecting

  /// The connection is open and messages can flow.
  Open

  /// `close` has been called; the closing handshake is in progress.
  Closing

  /// The connection has closed.
  Closed
}

/// A bidirectional, message-oriented network connection to a server.
///
/// See [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket) on MDN.
///
@external(javascript, "./web_socket.type.ts", "WebSocket$")
pub type WebSocket

/// The configuration for a [`WebSocket`](#WebSocket).
///
pub opaque type Builder {
  Builder(
    url: String,
    protocols: List(String),
    on_event: Option(fn(WebSocket, WebSocketEvent) -> Nil),
  )
}

/// Creates a `Builder` for a WebSocket connection to `uri`. Protocols
/// default to `[]` (no negotiation), and the event handler is unset.
///
pub fn from_uri(uri: Uri) -> Builder {
  Builder(url: uri.to_string(uri), protocols: [], on_event: None)
}

/// Sets the sub-protocols offered during the WebSocket handshake. Pass
/// `[]` to skip protocol negotiation.
///
pub fn with_protocols(builder: Builder, protocols: List(String)) -> Builder {
  Builder(..builder, protocols:)
}

/// Registers a handler invoked for every connection event:
/// [`Opened`](#WebSocketEvent), [`Text`](#WebSocketEvent),
/// [`Binary`](#WebSocketEvent), [`Errored`](#WebSocketEvent),
/// [`Disconnected`](#WebSocketEvent). The handler receives the
/// [`WebSocket`](#WebSocket) so it can reply via `send_*` while
/// dispatching on the [`WebSocketEvent`](#WebSocketEvent).
///
pub fn with_on_event(
  builder: Builder,
  run handler: fn(WebSocket, WebSocketEvent) -> a,
) -> Builder {
  Builder(
    ..builder,
    on_event: Some(fn(socket, event) {
      handler(socket, event)
      Nil
    }),
  )
}

/// Opens the WebSocket connection from the configured `Builder`. Returns
/// `Error(InvalidUrl)` when the URL isn't an absolute `ws:`/`wss:` URL or
/// contains a fragment, and `Error(InvalidProtocols)` when the protocols
/// list has duplicates or non-token entries.
///
pub fn build(builder: Builder) -> Result(WebSocket, WebSocketError) {
  do_build(builder.url, builder.protocols, builder.on_event)
}

@external(javascript, "./web_socket.ffi.mjs", "build")
@internal
pub fn do_build(
  url: String,
  protocols: List(String),
  on_event: Option(fn(WebSocket, WebSocketEvent) -> Nil),
) -> Result(WebSocket, WebSocketError)

/// A snapshot of the handshake-time fields of a
/// [`WebSocket`](#WebSocket), returned by [`info`](#info). For the
/// dynamic fields that change over the connection's lifecycle, use
/// [`ready_state`](#ready_state) and
/// [`buffered_amount`](#buffered_amount) directly.
///
pub type Info {
  Info(
    /// The URL the socket is connected to.
    url: String,
    /// The sub-protocol selected by the server during the handshake,
    /// or `""` if none was negotiated.
    protocol: String,
    /// The extensions selected by the server, or `""` if none.
    extensions: String,
  )
}

/// A snapshot of the socket's URL, negotiated sub-protocol, and server
/// extensions. These fields are fixed once the handshake completes.
///
@external(javascript, "./web_socket.ffi.mjs", "info")
pub fn info(socket: WebSocket) -> Info

/// The current state of the connection. Changes through
/// `Connecting` → `Open` → `Closing` → `Closed` over the
/// connection's lifecycle, so re-read this value rather than
/// caching it.
///
@external(javascript, "./web_socket.ffi.mjs", "ready_state")
pub fn ready_state(socket: WebSocket) -> ReadyState

/// The number of bytes of application data (UTF-8 text and binary
/// data) that have been queued using `send_*` but not yet been
/// transmitted to the network. Changes as messages queue and flush,
/// so re-read this value rather than caching it.
///
/// If the WebSocket connection is closed, this attribute's value
/// will only increase with each call to a `send_*` method. (The
/// number does not reset to zero once the connection closes.)
///
@external(javascript, "./web_socket.ffi.mjs", "buffered_amount")
pub fn buffered_amount(socket: WebSocket) -> Int

/// Closes the WebSocket connection with the default code `1000` and
/// no reason. Does nothing if the connection is already closing or
/// closed. For custom code or reason, use
/// [`close_with`](#close_with).
///
@external(javascript, "./web_socket.ffi.mjs", "close")
pub fn close(socket: WebSocket) -> Nil

/// Closes the WebSocket connection with the given `code` and
/// `reason`. Returns `Error(InvalidCloseCode(code))` if `code` is
/// outside `1000` or the range `3000`–`4999`, or
/// `Error(CloseReasonTooLong)` if `reason` exceeds `123` bytes when
/// encoded as UTF-8.
///
@external(javascript, "./web_socket.ffi.mjs", "close_with")
pub fn close_with(
  socket: WebSocket,
  code code: Int,
  reason reason: String,
) -> Result(Nil, WebSocketError)

/// Sends a `Blob` through the WebSocket. Returns `Error(NotOpen)` if the
/// connection is still `Connecting`. Data sent after the connection is
/// `Closing` or `Closed` is silently discarded per spec. Equivalent to
/// JavaScript's `WebSocket.send` with a `Blob` argument.
///
@external(javascript, "./web_socket.ffi.mjs", "send_blob")
pub fn send_blob(
  to socket: WebSocket,
  data data: Blob,
) -> Result(Nil, WebSocketError)

/// Sends a binary frame through the WebSocket. Returns `Error(NotOpen)`
/// if the connection is still `Connecting`. Data sent after the
/// connection is `Closing` or `Closed` is silently discarded per spec.
/// Equivalent to JavaScript's `WebSocket.send` with an `ArrayBuffer`
/// argument.
///
@external(javascript, "./web_socket.ffi.mjs", "send_binary")
pub fn send_binary(
  to socket: WebSocket,
  data data: BitArray,
) -> Result(Nil, WebSocketError)

/// Sends a text frame through the WebSocket. Returns `Error(NotOpen)` if
/// the connection is still `Connecting`. Data sent after the connection
/// is `Closing` or `Closed` is silently discarded per spec. Equivalent
/// to JavaScript's `WebSocket.send` with a `String` argument.
///
@external(javascript, "./web_socket.ffi.mjs", "send_text")
pub fn send_text(
  to socket: WebSocket,
  data data: String,
) -> Result(Nil, WebSocketError)
