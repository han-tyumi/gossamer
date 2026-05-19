import gleam/string
import gleam/uri.{type Uri}
import gleeunit/should
import gossamer/blob
import gossamer/web_socket

fn ws(url: String) -> Uri {
  let assert Ok(parsed) = uri.parse(url)
  parsed
}

pub fn build_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1")) |> web_socket.build
  web_socket.ready_state(ws) |> should.equal(web_socket.Connecting)
  web_socket.close(ws)
}

pub fn build_with_protocols_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1"))
    |> web_socket.with_protocols(["json"])
    |> web_socket.build
  web_socket.ready_state(ws) |> should.equal(web_socket.Connecting)
  web_socket.close(ws)
}

pub fn build_with_on_event_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1"))
    |> web_socket.with_on_event(fn(event, _socket) {
      case event {
        web_socket.Opened -> Nil
        web_socket.Text(_) -> Nil
        web_socket.Binary(_) -> Nil
        web_socket.Errored -> Nil
        web_socket.Disconnected(_) -> Nil
      }
    })
    |> web_socket.build
  web_socket.ready_state(ws) |> should.equal(web_socket.Connecting)
  web_socket.close(ws)
}

// `send` on a Connecting socket throws `InvalidStateError` per spec — we
// can exercise the error path without a real server by sending before the
// connection completes.

pub fn send_text_while_connecting_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1")) |> web_socket.build
  let assert Error(web_socket.NotOpen) = web_socket.send_text(ws, "hello")
  web_socket.close(ws)
}

pub fn send_binary_while_connecting_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1")) |> web_socket.build
  let assert Error(web_socket.NotOpen) = web_socket.send_binary(ws, <<1, 2, 3>>)
  web_socket.close(ws)
}

pub fn send_blob_while_connecting_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1")) |> web_socket.build
  let b = blob.from_string("hello", content_type: "")
  let assert Error(web_socket.NotOpen) = web_socket.send_blob(ws, b)
  web_socket.close(ws)
}

pub fn build_invalid_url_test() {
  web_socket.from_uri(ws("http://example.com"))
  |> web_socket.build
  |> should.equal(Error(web_socket.InvalidUrl))
}

pub fn build_invalid_protocols_test() {
  web_socket.from_uri(ws("ws://localhost:1"))
  |> web_socket.with_protocols(["json", "json"])
  |> web_socket.build
  |> should.equal(Error(web_socket.InvalidProtocols))
}

pub fn close_with_valid_code_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1")) |> web_socket.build
  web_socket.close_with(ws, 1000, "bye") |> should.equal(Ok(Nil))
}

pub fn close_with_invalid_code_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1")) |> web_socket.build
  web_socket.close_with(ws, 2000, "bye")
  |> should.equal(Error(web_socket.InvalidCloseCode(2000)))
  web_socket.close(ws)
}

pub fn close_with_reason_too_long_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1")) |> web_socket.build
  let long_reason = string.repeat("x", 200)
  web_socket.close_with(ws, 1000, long_reason)
  |> should.equal(Error(web_socket.CloseReasonTooLong))
  web_socket.close(ws)
}

pub fn long_string_url_test() {
  let assert Ok(ws) =
    web_socket.from_uri(ws("ws://localhost:1/")) |> web_socket.build
  web_socket.info(ws).url |> should.equal("ws://localhost:1/")
  web_socket.close(ws)
}
