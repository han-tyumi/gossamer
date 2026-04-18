import gleeunit/should
import gossamer/ready_state
import gossamer/web_socket

pub fn ready_state_connecting_test() {
  let assert Ok(ws) = web_socket.new("ws://localhost:1")
  web_socket.ready_state(ws) |> should.equal(ready_state.Connecting)
  web_socket.close(ws) |> should.be_ok
}

pub fn new_with_protocols_test() {
  let assert Ok(ws) =
    web_socket.new_with_protocols("ws://localhost:1", ["json"])
  web_socket.ready_state(ws) |> should.equal(ready_state.Connecting)
  web_socket.close(ws) |> should.be_ok
}
