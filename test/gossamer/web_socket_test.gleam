import gleam/uri
import gleeunit/should
import gossamer/blob
import gossamer/web_socket

pub fn build_test() {
  let assert Ok(ws) =
    web_socket.from_url_string("ws://localhost:1") |> web_socket.build
  web_socket.ready_state(ws) |> should.equal(web_socket.Connecting)
  web_socket.close(ws)
}

pub fn build_with_protocols_test() {
  let assert Ok(ws) =
    web_socket.from_url_string("ws://localhost:1")
    |> web_socket.with_protocols(["json"])
    |> web_socket.build
  web_socket.ready_state(ws) |> should.equal(web_socket.Connecting)
  web_socket.close(ws)
}

pub fn build_with_binary_type_test() {
  let assert Ok(ws) =
    web_socket.from_url_string("ws://localhost:1")
    |> web_socket.with_binary_type(web_socket.ArrayBuffer)
    |> web_socket.build
  web_socket.binary_type(ws) |> should.equal(web_socket.ArrayBuffer)
  web_socket.close(ws)
}

pub fn build_from_uri_test() {
  let assert Ok(u) = uri.parse("ws://localhost:1")
  let assert Ok(ws) = web_socket.from_uri(u) |> web_socket.build
  web_socket.ready_state(ws) |> should.equal(web_socket.Connecting)
  web_socket.close(ws)
}

pub fn build_from_uri_with_protocols_test() {
  let assert Ok(u) = uri.parse("ws://localhost:1")
  let assert Ok(ws) =
    web_socket.from_uri(u)
    |> web_socket.with_protocols(["json"])
    |> web_socket.build
  web_socket.ready_state(ws) |> should.equal(web_socket.Connecting)
  web_socket.close(ws)
}

pub fn from_uri_parity_test() {
  // String-input and Uri-input constructors produce sockets with the same
  // observable url.
  let href = "ws://localhost:1/"
  let assert Ok(u) = uri.parse(href)

  let assert Ok(from_string) =
    web_socket.from_url_string(href) |> web_socket.build
  let assert Ok(from_uri) = web_socket.from_uri(u) |> web_socket.build

  web_socket.url(from_string) |> should.equal(web_socket.url(from_uri))
  web_socket.close(from_string)
  web_socket.close(from_uri)
}

// `send` on a Connecting socket throws `InvalidStateError` per spec — we
// can exercise the error path without a real server by sending before the
// connection completes.

pub fn send_string_while_connecting_test() {
  let assert Ok(ws) =
    web_socket.from_url_string("ws://localhost:1") |> web_socket.build
  web_socket.send_string(ws, "hello") |> should.be_error
  web_socket.close(ws)
}

pub fn send_bytes_while_connecting_test() {
  let assert Ok(ws) =
    web_socket.from_url_string("ws://localhost:1") |> web_socket.build
  web_socket.send_bytes(ws, <<1, 2, 3>>) |> should.be_error
  web_socket.close(ws)
}

pub fn send_blob_while_connecting_test() {
  let assert Ok(ws) =
    web_socket.from_url_string("ws://localhost:1") |> web_socket.build
  let b = blob.from_string("hello")
  web_socket.send_blob(ws, b) |> should.be_error
  web_socket.close(ws)
}

// Bun doesn't enforce the WebSocket close-code check (`InvalidAccessError`
// for codes outside `1000` and `3000`–`4999`), so a portable invalid-code
// error-path test isn't possible. The Result wrap is still exercised by the
// `send_*` tests above on a Connecting socket.
pub fn close_with_valid_code_test() {
  let assert Ok(ws) =
    web_socket.from_url_string("ws://localhost:1") |> web_socket.build
  web_socket.close_with(ws, 1000, "bye") |> should.equal(Ok(Nil))
}
