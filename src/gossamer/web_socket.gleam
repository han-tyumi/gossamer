import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/binary_type.{type BinaryType}
import gossamer/blob.{type Blob}
import gossamer/js_error.{type JsError}
import gossamer/message_event.{type MessageEvent}
import gossamer/ready_state.{type ReadyState}
import gossamer/typed_array.{type TypedArray}
import gossamer/url.{type URL}

// TODO: Happy-path coverage for `send_*` and `on_*` requires a live
// WebSocket server, which can't be created cross-runtime from pure
// Gleam. Tests currently cover the constructors, `ready_state`, `close`,
// `close_with`, and the `send_*` error path on a Connecting socket.

pub type CloseEvent {
  CloseEvent(code: Int, reason: String, was_clean: Bool)
}

/// A bidirectional, message-oriented network connection to a server.
///
/// See [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket) on MDN.
///
@external(javascript, "./web_socket.type.ts", "WebSocket$")
pub type WebSocket

/// Creates a new `WebSocket` connection to the URL given as a string.
/// Returns an error if `url` is not a valid `ws:` or `wss:` URL.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(ws) = web_socket.from_url_string("ws://localhost:8080")
/// ```
///
@external(javascript, "./web_socket.ffi.mjs", "from_url_string")
pub fn from_url_string(url: String) -> Result(WebSocket, JsError)

/// Creates a new `WebSocket` connection to the URL given as a string, with
/// the specified sub-protocols. Returns an error if `url` is not a valid
/// `ws:` or `wss:` URL, or if `protocols` contains duplicates or invalid
/// entries.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(ws) = web_socket.from_url_string_with_protocols("ws://localhost:8080", ["json"])
/// ```
///
@external(javascript, "./web_socket.ffi.mjs", "from_url_string_with_protocols")
pub fn from_url_string_with_protocols(
  url: String,
  with protocols: List(String),
) -> Result(WebSocket, JsError)

/// Creates a new `WebSocket` connection to `url`. Returns an error if
/// `url`'s scheme is not `ws:` or `wss:`.
///
@external(javascript, "./web_socket.ffi.mjs", "from_url")
pub fn from_url(url: URL) -> Result(WebSocket, JsError)

/// Creates a new `WebSocket` connection to `url` with the specified
/// sub-protocols. Returns an error if `url`'s scheme is not `ws:` or
/// `wss:`, or if `protocols` contains duplicates or invalid entries.
///
@external(javascript, "./web_socket.ffi.mjs", "from_url_with_protocols")
pub fn from_url_with_protocols(
  url: URL,
  with protocols: List(String),
) -> Result(WebSocket, JsError)

@external(javascript, "./web_socket.ffi.mjs", "binary_type")
pub fn binary_type(of socket: WebSocket) -> BinaryType

@external(javascript, "./web_socket.ffi.mjs", "set_binary_type")
pub fn set_binary_type(of socket: WebSocket, to value: BinaryType) -> Nil

/// Returns the number of bytes of application data (UTF-8 text and binary
/// data) that have been queued using `send` but not yet been transmitted to
/// the network.
///
/// If the WebSocket connection is closed, this attribute's value will only
/// increase with each call to the `send` method. (The number does not reset
/// to zero once the connection closes.)
///
@external(javascript, "./web_socket.ffi.mjs", "buffered_amount")
pub fn buffered_amount(of socket: WebSocket) -> Int

@external(javascript, "./web_socket.ffi.mjs", "extensions")
pub fn extensions(of socket: WebSocket) -> String

@external(javascript, "./web_socket.ffi.mjs", "protocol")
pub fn protocol(of socket: WebSocket) -> String

@external(javascript, "./web_socket.ffi.mjs", "ready_state")
pub fn ready_state(of socket: WebSocket) -> ReadyState

@external(javascript, "./web_socket.ffi.mjs", "url")
pub fn url(of socket: WebSocket) -> String

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

/// Sends a string through the WebSocket. Returns an error if the
/// connection is still connecting. Data sent after the connection is
/// closing or closed is silently discarded.
///
@external(javascript, "./web_socket.ffi.mjs", "send_string")
pub fn send_string(
  to socket: WebSocket,
  data data: String,
) -> Result(Nil, JsError)

/// Sends binary data as a `TypedArray` through the WebSocket. Returns
/// an error if the connection is still connecting. Data sent after the
/// connection is closing or closed is silently discarded.
///
@external(javascript, "./web_socket.ffi.mjs", "send_typed_array")
pub fn send_typed_array(
  to socket: WebSocket,
  data data: TypedArray,
) -> Result(Nil, JsError)

/// Sends a `Blob` through the WebSocket. Returns an error if the
/// connection is still connecting. Data sent after the connection is
/// closing or closed is silently discarded.
///
@external(javascript, "./web_socket.ffi.mjs", "send_blob")
pub fn send_blob(to socket: WebSocket, data data: Blob) -> Result(Nil, JsError)

/// Sends an `ArrayBuffer` through the WebSocket. Returns an error if
/// the connection is still connecting. Data sent after the connection
/// is closing or closed is silently discarded.
///
@external(javascript, "./web_socket.ffi.mjs", "send_buffer")
pub fn send_buffer(
  to socket: WebSocket,
  data data: ArrayBuffer,
) -> Result(Nil, JsError)

@external(javascript, "./web_socket.ffi.mjs", "on_open")
pub fn on_open(socket: WebSocket, run handler: fn() -> a) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "on_message")
pub fn on_message(socket: WebSocket, run handler: fn(MessageEvent) -> a) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "on_error")
pub fn on_error(socket: WebSocket, run handler: fn() -> a) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "on_close")
pub fn on_close(socket: WebSocket, run handler: fn(CloseEvent) -> a) -> Nil
