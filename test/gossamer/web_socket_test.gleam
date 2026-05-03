import gleeunit/should
import gossamer/array_buffer
import gossamer/blob
import gossamer/data_view
import gossamer/ready_state
import gossamer/typed_array
import gossamer/uint8_array
import gossamer/url
import gossamer/web_socket

pub fn ready_state_connecting_test() {
  let assert Ok(ws) = web_socket.from_url_string("ws://localhost:1")
  web_socket.ready_state(ws) |> should.equal(ready_state.Connecting)
  web_socket.close(ws)
}

pub fn from_url_string_with_protocols_test() {
  let assert Ok(ws) =
    web_socket.from_url_string_with_protocols("ws://localhost:1", ["json"])
  web_socket.ready_state(ws) |> should.equal(ready_state.Connecting)
  web_socket.close(ws)
}

pub fn from_url_test() {
  let assert Ok(u) = url.new("ws://localhost:1")
  let assert Ok(ws) = web_socket.from_url(u)
  web_socket.ready_state(ws) |> should.equal(ready_state.Connecting)
  web_socket.close(ws)
}

pub fn from_url_with_protocols_test() {
  let assert Ok(u) = url.new("ws://localhost:1")
  let assert Ok(ws) = web_socket.from_url_with_protocols(u, ["json"])
  web_socket.ready_state(ws) |> should.equal(ready_state.Connecting)
  web_socket.close(ws)
}

pub fn from_url_parity_test() {
  // String-input and URL-input constructors produce sockets with the same
  // observable url.
  let href = "ws://localhost:1/"
  let assert Ok(u) = url.new(href)

  let assert Ok(from_string) = web_socket.from_url_string(href)
  let assert Ok(from_url) = web_socket.from_url(u)

  web_socket.url(from_string) |> should.equal(web_socket.url(from_url))
  web_socket.close(from_string)
  web_socket.close(from_url)
}

// `send` on a Connecting socket throws `InvalidStateError` per spec — we
// can exercise the error path without a real server by sending before the
// connection completes.

pub fn send_string_while_connecting_test() {
  let assert Ok(ws) = web_socket.from_url_string("ws://localhost:1")
  web_socket.send_string(ws, "hello") |> should.be_error
  web_socket.close(ws)
}

pub fn send_typed_array_while_connecting_test() {
  let assert Ok(ws) = web_socket.from_url_string("ws://localhost:1")
  let bytes = typed_array.Uint8(uint8_array.from_list([1, 2, 3]))
  web_socket.send_typed_array(ws, bytes) |> should.be_error
  web_socket.close(ws)
}

pub fn send_blob_while_connecting_test() {
  let assert Ok(ws) = web_socket.from_url_string("ws://localhost:1")
  let b = blob.from_string("hello")
  web_socket.send_blob(ws, b) |> should.be_error
  web_socket.close(ws)
}

pub fn send_buffer_while_connecting_test() {
  let assert Ok(ws) = web_socket.from_url_string("ws://localhost:1")
  let assert Ok(buffer) = array_buffer.new(4)
  web_socket.send_buffer(ws, buffer) |> should.be_error
  web_socket.close(ws)
}

pub fn send_data_view_while_connecting_test() {
  let assert Ok(ws) = web_socket.from_url_string("ws://localhost:1")
  let assert Ok(buffer) = array_buffer.new(4)
  let assert Ok(view) = data_view.new(buffer)
  web_socket.send_data_view(ws, view) |> should.be_error
  web_socket.close(ws)
}

// Bun doesn't enforce the WebSocket close-code check (`InvalidAccessError`
// for codes outside `1000` and `3000`–`4999`), so a portable invalid-code
// error-path test isn't possible. The Result wrap is still exercised by the
// `send_*` tests above on a Connecting socket.
pub fn close_with_valid_code_test() {
  let assert Ok(ws) = web_socket.from_url_string("ws://localhost:1")
  web_socket.close_with(ws, 1000, "bye") |> should.equal(Ok(Nil))
}
