import gleam/dynamic/decode
import gleam/javascript/promise
import gleeunit/should
import gossamer/array_buffer
import gossamer/worker

pub fn new_default_builder_test() {
  let _ = worker.new("gossamer/worker_parent_fixture")
}

pub fn round_trip_string_test() {
  let #(p, resolve) = promise.start()

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_fixture")
    |> worker.with_on_message(fn(_worker, data) {
      let assert Ok(value) = decode.run(data, decode.string)
      resolve(value)
      Nil
    })
    |> worker.build

  let assert Ok(_) = worker.post_message(w, "hello")

  use value <- promise.map(p)
  value |> should.equal("hello")
  worker.terminate(w)
}

pub fn round_trip_array_buffer_as_bit_array_test() {
  let #(p, resolve) = promise.start()

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_fixture")
    |> worker.with_on_message(fn(_worker, data) {
      let assert Ok(bytes) = decode.run(data, decode.bit_array)
      resolve(bytes)
      Nil
    })
    |> worker.build

  let buffer = array_buffer.from_bit_array(<<1, 2, 3>>)
  let assert Ok(_) = worker.post_message(w, buffer)

  use bytes <- promise.map(p)
  bytes |> should.equal(<<1, 2, 3>>)
  worker.terminate(w)
}

pub fn post_message_non_cloneable_test() {
  let assert Ok(w) =
    worker.new("gossamer/worker_parent_fixture") |> worker.build
  worker.post_message(w, fn() { Nil }) |> should.be_error
  worker.terminate(w)
}

pub fn set_on_message_replaces_previous_handler_test() {
  let #(p, resolve) = promise.start()

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_replace_fixture")
    |> worker.with_on_message(fn(_worker, data) {
      let assert Ok(value) = decode.run(data, decode.string)
      resolve(value)
      Nil
    })
    |> worker.build

  let assert Ok(_) = worker.post_message(w, "echoed")

  use value <- promise.map(p)
  value |> should.equal("echoed")
  worker.terminate(w)
}
