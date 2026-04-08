import gleam/dynamic.{type Dynamic}
import gossamer/binary_type.{type BinaryType}
import gossamer/close_event.{type CloseEvent}
import gossamer/message_event.{type MessageEvent}
import gossamer/ready_state.{type ReadyState}

// TODO: Most WebSocket functions are untested — requires a live WebSocket
// server which can't be created cross-runtime from pure Gleam. Only `new`,
// `new_with_protocols`, `ready_state`, and `close` are tested.

/// Provides the API for creating and managing a WebSocket connection to a
/// server, as well as for sending and receiving data on the connection.
///
@external(javascript, "./web_socket.type.ts", "WebSocket$")
pub type WebSocket

/// Creates a new `WebSocket` connection to the given URL.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(ws) = web_socket.new("ws://localhost:8080")
/// ```
///
@external(javascript, "./web_socket.ffi.mjs", "new_")
pub fn new(url: String) -> Result(WebSocket, String)

/// Creates a new `WebSocket` connection to the given URL with the
/// specified sub-protocols.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(ws) = web_socket.new_with_protocols("ws://localhost:8080", ["json"])
/// ```
///
@external(javascript, "./web_socket.ffi.mjs", "new_with_protocols")
pub fn new_with_protocols(
  url: String,
  protocols: List(String),
) -> Result(WebSocket, String)

@external(javascript, "./web_socket.ffi.mjs", "binary_type")
pub fn binary_type(socket: WebSocket) -> BinaryType

@external(javascript, "./web_socket.ffi.mjs", "set_binary_type")
pub fn set_binary_type(socket: WebSocket, value: BinaryType) -> Nil

/// Returns the number of bytes of application data (UTF-8 text and binary
/// data) that have been queued using `send` but not yet been transmitted to
/// the network.
///
/// If the WebSocket connection is closed, this attribute's value will only
/// increase with each call to the `send` method. (The number does not reset
/// to zero once the connection closes.)
///
@external(javascript, "./web_socket.ffi.mjs", "buffered_amount")
pub fn buffered_amount(socket: WebSocket) -> Int

@external(javascript, "./web_socket.ffi.mjs", "extensions")
pub fn extensions(socket: WebSocket) -> String

@external(javascript, "./web_socket.ffi.mjs", "protocol")
pub fn protocol(socket: WebSocket) -> String

@external(javascript, "./web_socket.ffi.mjs", "ready_state")
pub fn ready_state(socket: WebSocket) -> ReadyState

@external(javascript, "./web_socket.ffi.mjs", "url")
pub fn url(socket: WebSocket) -> String

@external(javascript, "./web_socket.ffi.mjs", "close")
pub fn close(socket: WebSocket) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "close_with")
pub fn close_with(socket: WebSocket, code: Int, reason: String) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "send")
pub fn send(socket: WebSocket, data: String) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "send_dynamic")
pub fn send_dynamic(socket: WebSocket, data: Dynamic) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "on_open")
pub fn on_open(socket: WebSocket, handler: fn() -> Nil) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "on_message")
pub fn on_message(socket: WebSocket, handler: fn(MessageEvent) -> Nil) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "on_error")
pub fn on_error(socket: WebSocket, handler: fn() -> Nil) -> Nil

@external(javascript, "./web_socket.ffi.mjs", "on_close")
pub fn on_close(socket: WebSocket, handler: fn(CloseEvent) -> Nil) -> Nil
