//// Worker-side fixture used by worker_test.gleam to verify
//// MessagePort transfer. The fixture expects its first parent
//// message to BE a transferred MessagePort. It extracts the port via
//// message_port.from_dynamic and sets up an echo handler on it —
//// anything sent to the port from the parent is echoed back on the
//// same port.

import gossamer/message_port
import gossamer/worker_parent

pub fn main() {
  worker_parent.set_on_message(fn(data) {
    let assert Ok(port) = message_port.from_dynamic(data)
    message_port.set_on_message(port, fn(message, p) {
      let _ = message_port.post_message(p, message)
      Nil
    })
    Nil
  })
}
