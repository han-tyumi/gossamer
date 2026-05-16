//// Worker-side fixture used by worker_test.gleam — the worker spawns
//// this module and `main()` is invoked by a small bootstrap. The
//// fixture echoes received messages back to the parent via
//// gossamer/worker_self, matching the pattern a Gleam user would use
//// for their own worker entry-point module.

import gossamer/worker_self

pub fn main() {
  worker_self.set_on_message(fn(data) {
    let _ = worker_self.post_message(data)
    Nil
  })
}
