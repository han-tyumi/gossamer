import gleam/option.{type Option, None, Some}
import gleam/uri.{type Uri}
import gossamer/blob.{type Blob}
import gossamer/js_error.{type JsError}
import gossamer/message_event.{type MessageEvent}

// TODO: Happy-path coverage for `send_*` and listener delivery requires a
// live WebSocket server, which can't be created cross-runtime from pure
// Gleam. Tests currently cover the constructors, `ready_state`, `close`,
// `close_with`, and the `send_*` error path on a Connecting socket.

/// The data carried by a WebSocket close event.
///
pub type CloseEvent {
  CloseEvent(code: Int, reason: String, was_clean: Bool)
}

/// The format binary messages arrive as on a `WebSocket`.
///
/// Unrecognized values use `Other(String)`.
///
pub type BinaryType {
  ArrayBuffer
  Blob
  Other(String)
}

/// The state of a `WebSocket` connection.
///
pub type ReadyState {
  Connecting
  Open
  Closing
  Closed
}

/// A bidirectional, message-oriented network connection to a server.
///
/// See [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket) on MDN.
///
@external(javascript, "./web_socket.type.ts", "WebSocket$")
pub type WebSocket

/// The configuration for a `WebSocket`. Construct with `from_url_string`
/// or `from_uri`, refine with `with_protocols` / `with_binary_type` and
/// listener setters (`on_open`, `on_message`, `on_error`, `on_close`),
/// then call `build` to open the connection.
///
pub type Builder {
  Builder(
    url: String,
    protocols: List(String),
    binary_type: Option(BinaryType),
    on_open: Option(fn() -> Nil),
    on_message: Option(fn(MessageEvent) -> Nil),
    on_error: Option(fn() -> Nil),
    on_close: Option(fn(CloseEvent) -> Nil),
  )
}

/// Creates a `Builder` for a WebSocket connection to the URL given as a
/// string. Protocols default to `[]` (no negotiation), and the binary
/// type and listeners are unset.
///
pub fn from_url_string(url: String) -> Builder {
  Builder(
    url:,
    protocols: [],
    binary_type: None,
    on_open: None,
    on_message: None,
    on_error: None,
    on_close: None,
  )
}

/// Creates a `Builder` for a WebSocket connection to `uri`. Protocols
/// default to `[]` (no negotiation), and the binary type and listeners
/// are unset.
///
pub fn from_uri(uri: Uri) -> Builder {
  from_url_string(uri.to_string(uri))
}

/// Sets the sub-protocols offered during the WebSocket handshake. Pass
/// `[]` to skip protocol negotiation.
///
pub fn with_protocols(builder: Builder, value: List(String)) -> Builder {
  Builder(..builder, protocols: value)
}

/// Sets the format binary messages arrive as on the socket. Defaults to
/// the runtime's default (`Blob` in browsers, `ArrayBuffer` elsewhere).
///
pub fn with_binary_type(builder: Builder, value: BinaryType) -> Builder {
  Builder(..builder, binary_type: Some(value))
}

/// Registers a handler invoked when the connection opens.
///
pub fn on_open(builder: Builder, run handler: fn() -> a) -> Builder {
  Builder(
    ..builder,
    on_open: Some(fn() {
      handler()
      Nil
    }),
  )
}

/// Registers a handler invoked for each incoming message.
///
pub fn on_message(
  builder: Builder,
  run handler: fn(MessageEvent) -> a,
) -> Builder {
  Builder(
    ..builder,
    on_message: Some(fn(event) {
      handler(event)
      Nil
    }),
  )
}

/// Registers a handler invoked when the connection encounters an error.
///
pub fn on_error(builder: Builder, run handler: fn() -> a) -> Builder {
  Builder(
    ..builder,
    on_error: Some(fn() {
      handler()
      Nil
    }),
  )
}

/// Registers a handler invoked when the connection closes.
///
pub fn on_close(builder: Builder, run handler: fn(CloseEvent) -> a) -> Builder {
  Builder(
    ..builder,
    on_close: Some(fn(event) {
      handler(event)
      Nil
    }),
  )
}

/// Opens the WebSocket connection from the configured `Builder`.
/// Returns an error if the URL is not a valid `ws:` or `wss:` URL, or if
/// `protocols` contains duplicates or invalid entries.
///
@external(javascript, "./web_socket.ffi.mjs", "build")
pub fn build(builder: Builder) -> Result(WebSocket, JsError)

/// The format binary messages arrive as on this socket.
///
@external(javascript, "./web_socket.ffi.mjs", "binary_type")
pub fn binary_type(socket: WebSocket) -> BinaryType

/// The number of bytes of application data (UTF-8 text and binary data)
/// that have been queued using `send_*` but not yet been transmitted to
/// the network.
///
/// If the WebSocket connection is closed, this attribute's value will only
/// increase with each call to a `send_*` method. (The number does not reset
/// to zero once the connection closes.)
///
@external(javascript, "./web_socket.ffi.mjs", "buffered_amount")
pub fn buffered_amount(socket: WebSocket) -> Int

/// The extensions selected by the server, if any.
///
@external(javascript, "./web_socket.ffi.mjs", "extensions")
pub fn extensions(socket: WebSocket) -> String

/// The sub-protocol selected by the server during the handshake, or `""`
/// if none was negotiated.
///
@external(javascript, "./web_socket.ffi.mjs", "protocol")
pub fn protocol(socket: WebSocket) -> String

/// The current state of the connection.
///
@external(javascript, "./web_socket.ffi.mjs", "ready_state")
pub fn ready_state(socket: WebSocket) -> ReadyState

/// The URL the socket is connected to.
///
@external(javascript, "./web_socket.ffi.mjs", "url")
pub fn url(socket: WebSocket) -> String

/// Closes the WebSocket connection. Does nothing if the connection is
/// already closing or closed.
///
@external(javascript, "./web_socket.ffi.mjs", "close")
pub fn close(socket: WebSocket) -> Nil

/// Closes the WebSocket connection with the given code and reason. Returns an
/// error if the code is invalid (must be `1000` or `3000`–`4999`) or the
/// reason exceeds `123` bytes.
///
@external(javascript, "./web_socket.ffi.mjs", "close_with")
pub fn close_with(
  socket: WebSocket,
  code code: Int,
  reason reason: String,
) -> Result(Nil, JsError)

/// Sends a `Blob` through the WebSocket. Returns an error if the
/// connection is still connecting. Data sent after the connection is
/// closing or closed is silently discarded.
///
@external(javascript, "./web_socket.ffi.mjs", "send_blob")
pub fn send_blob(to socket: WebSocket, data data: Blob) -> Result(Nil, JsError)

/// Sends binary data through the WebSocket. Returns an error if the
/// connection is still connecting. Data sent after the connection is
/// closing or closed is silently discarded.
///
@external(javascript, "./web_socket.ffi.mjs", "send_bytes")
pub fn send_bytes(
  to socket: WebSocket,
  data data: BitArray,
) -> Result(Nil, JsError)

/// Sends a string through the WebSocket. Returns an error if the
/// connection is still connecting. Data sent after the connection is
/// closing or closed is silently discarded.
///
@external(javascript, "./web_socket.ffi.mjs", "send_string")
pub fn send_string(
  to socket: WebSocket,
  data data: String,
) -> Result(Nil, JsError)
