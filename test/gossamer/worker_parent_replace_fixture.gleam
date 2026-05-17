//// Worker-side fixture used to verify that worker_parent.set_on_message
//// replaces a previously-registered handler. The first handler posts a
//// sentinel back to the parent; the second handler echoes the received
//// data. The parent expects to see the echoed data, not the sentinel.

import gossamer/worker_parent

pub fn main() {
  worker_parent.set_on_message(fn(_) {
    let _ = worker_parent.post_message("FIRST-HANDLER-LEAKED")
    Nil
  })
  worker_parent.set_on_message(fn(data) {
    let _ = worker_parent.post_message(data)
    Nil
  })
}
