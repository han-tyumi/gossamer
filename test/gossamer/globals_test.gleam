import gleam/javascript/promise
import gleeunit/should
import gossamer

pub fn structured_clone_int_test() {
  gossamer.structured_clone(42) |> should.equal(Ok(42))
}

pub fn structured_clone_string_test() {
  gossamer.structured_clone("hello") |> should.equal(Ok("hello"))
}

pub fn structured_clone_tuple_test() {
  gossamer.structured_clone(#(1, "two")) |> should.equal(Ok(#(1, "two")))
}

pub fn btoa_test() {
  gossamer.btoa("Hello") |> should.equal(Ok("SGVsbG8="))
}

pub fn atob_test() {
  gossamer.atob("SGVsbG8=") |> should.equal(Ok("Hello"))
}

pub fn btoa_atob_roundtrip_test() {
  let assert Ok(encoded) = gossamer.btoa("roundtrip test")
  let assert Ok(decoded) = gossamer.atob(encoded)
  should.equal(decoded, "roundtrip test")
}

pub fn atob_invalid_test() {
  gossamer.atob("!!!invalid!!!") |> should.be_error
}

pub fn user_agent_test() {
  let agent = gossamer.user_agent()
  should.be_true(agent != "")
}

pub fn set_timeout_and_clear_test() {
  let #(p, resolve) = promise.start()

  let id =
    gossamer.set_timeout(10, fn() {
      resolve("fired")
      Nil
    })

  // Verify we get a valid timer id.
  should.be_true(id >= 0)

  use value <- promise.map(p)
  should.equal(value, "fired")
}

pub fn clear_timeout_test() {
  let id = gossamer.set_timeout(100_000, fn() { Nil })
  gossamer.clear_timeout(id)
}

pub fn set_interval_and_clear_test() {
  let id = gossamer.set_interval(100_000, fn() { Nil })
  should.be_true(id >= 0)
  gossamer.clear_interval(id)
}

pub fn queue_microtask_test() {
  let #(p, resolve) = promise.start()

  gossamer.queue_microtask(fn() {
    resolve("microtask ran")
    Nil
  })

  use value <- promise.map(p)
  should.equal(value, "microtask ran")
}
