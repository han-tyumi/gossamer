import gleeunit/should
import gossamer/ready_state
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
