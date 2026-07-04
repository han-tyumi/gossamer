//// Worker-side fixture used by worker_test.gleam to verify that
//// worker_parent.post_message returns an error for values the
//// structured-clone algorithm can't serialize. The fixture attempts to
//// post a function and reports the outcome to the parent as a sentinel
//// string.

import gossamer/worker_parent

pub fn main() {
  let _ = case worker_parent.post_message(fn() { Nil }) {
    Error(_) -> worker_parent.post_message("non-cloneable-error")
    Ok(_) -> worker_parent.post_message("non-cloneable-ok")
  }
  Nil
}
