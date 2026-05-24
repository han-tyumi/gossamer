import gleam/dynamic/decode
import gleam/javascript/promise
import gleeunit/should
import gossamer/array_buffer
import gossamer/message_channel
import gossamer/message_port
import gossamer/worker

pub fn new_default_builder_test() {
  let _ = worker.new("gossamer/worker_parent_fixture")
}

pub fn round_trip_string_test() {
  let #(p, resolve) = promise.start()

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_fixture")
    |> worker.with_on_message(fn(data, _worker) {
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
    |> worker.with_on_message(fn(data, _worker) {
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

pub fn transfer_port_to_worker_test() {
  let #(port1, port2) = message_channel.new()
  let #(p, resolve) = promise.start()

  message_port.set_on_message(port2, fn(data, _port) {
    let assert Ok(value) = decode.run(data, decode.string)
    resolve(value)
    Nil
  })

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_port_echo_fixture") |> worker.build

  let assert Ok(_) = worker.post_message(w, port1)
  let assert Ok(_) = message_port.post_message(port2, "hello over channel")

  use value <- promise.map(p)
  value |> should.equal("hello over channel")
  message_port.close(port2)
  worker.terminate(w)
}

pub fn round_trip_tuple_test() {
  let #(p, resolve) = promise.start()

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_fixture")
    |> worker.with_on_message(fn(data, _worker) {
      let decoder = {
        use first <- decode.field(0, decode.string)
        use second <- decode.field(1, decode.int)
        decode.success(#(first, second))
      }
      let assert Ok(value) = decode.run(data, decoder)
      resolve(value)
      Nil
    })
    |> worker.build

  let assert Ok(_) = worker.post_message(w, #("hello", 42))

  use value <- promise.map(p)
  value |> should.equal(#("hello", 42))
  worker.terminate(w)
}

pub type RoundTripRecord {
  RoundTripRecord(id: String, count: Int)
}

pub fn round_trip_record_fields_test() {
  let #(p, resolve) = promise.start()

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_fixture")
    |> worker.with_on_message(fn(data, _worker) {
      let decoder = {
        use id <- decode.field("id", decode.string)
        use count <- decode.field("count", decode.int)
        decode.success(RoundTripRecord(id, count))
      }
      let assert Ok(value) = decode.run(data, decoder)
      resolve(value)
      Nil
    })
    |> worker.build

  let assert Ok(_) =
    worker.post_message(w, RoundTripRecord(id: "abc", count: 7))

  use value <- promise.map(p)
  value |> should.equal(RoundTripRecord(id: "abc", count: 7))
  worker.terminate(w)
}

pub type DemoNested {
  DemoNested(label: String)
}

pub type DemoPayload {
  DemoPayload(
    name: String,
    count: Int,
    weight: Float,
    active: Bool,
    coords: #(Int, Int),
    nested: DemoNested,
  )
}

pub fn round_trip_demo_payload_test() {
  let #(p, resolve) = promise.start()

  let nested_decoder = {
    use label <- decode.field("label", decode.string)
    decode.success(DemoNested(label:))
  }
  let coords_decoder = {
    use x <- decode.field(0, decode.int)
    use y <- decode.field(1, decode.int)
    decode.success(#(x, y))
  }
  let payload_decoder = {
    use name <- decode.field("name", decode.string)
    use count <- decode.field("count", decode.int)
    use weight <- decode.field("weight", decode.float)
    use active <- decode.field("active", decode.bool)
    use coords <- decode.field("coords", coords_decoder)
    use nested <- decode.field("nested", nested_decoder)
    decode.success(DemoPayload(
      name:,
      count:,
      weight:,
      active:,
      coords:,
      nested:,
    ))
  }

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_fixture")
    |> worker.with_on_message(fn(data, _worker) {
      let assert Ok(value) = decode.run(data, payload_decoder)
      resolve(value)
      Nil
    })
    |> worker.build

  let payload =
    DemoPayload(
      name: "demo",
      count: 42,
      weight: 3.14,
      active: True,
      coords: #(10, 20),
      nested: DemoNested(label: "inner"),
    )

  let assert Ok(_) = worker.post_message(w, payload)

  use value <- promise.map(p)
  value |> should.equal(payload)
  worker.terminate(w)
}

pub fn set_on_message_replaces_previous_handler_test() {
  let #(p, resolve) = promise.start()

  let assert Ok(w) =
    worker.new("gossamer/worker_parent_replace_fixture")
    |> worker.with_on_message(fn(data, _worker) {
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
