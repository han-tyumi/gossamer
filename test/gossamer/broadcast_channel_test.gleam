import gleam/dynamic/decode
import gleam/javascript/promise
import gleam/list
import gleeunit/should
import gossamer/broadcast_channel
import gossamer/worker

pub fn new_test() {
  let channel = broadcast_channel.new("test-channel-new")
  broadcast_channel.name(channel) |> should.equal("test-channel-new")
  broadcast_channel.close(channel)
}

pub fn round_trip_test() {
  let sender = broadcast_channel.new("test-channel-round-trip")
  let receiver = broadcast_channel.new("test-channel-round-trip")

  let #(p, resolve) = promise.start()

  broadcast_channel.set_on_message(receiver, fn(data) {
    let assert Ok(value) = decode.run(data, decode.string)
    resolve(value)
    Nil
  })

  let assert Ok(_) = broadcast_channel.post_message(sender, "hello")

  use value <- promise.map(p)
  value |> should.equal("hello")
  broadcast_channel.close(sender)
  broadcast_channel.close(receiver)
}

pub fn post_message_non_cloneable_test() {
  let channel = broadcast_channel.new("test-channel-non-cloneable")
  broadcast_channel.post_message(channel, fn() { Nil }) |> should.be_error
  broadcast_channel.close(channel)
}

pub fn cross_worker_fanout_test() {
  let #(p1_ready, r1_ready) = promise.start()
  let #(p1_echo, r1_echo) = promise.start()
  let #(p2_ready, r2_ready) = promise.start()
  let #(p2_echo, r2_echo) = promise.start()

  let handler = fn(ready_resolve, echo_resolve) {
    fn(_worker, data) {
      let assert Ok(msg) = decode.run(data, decode.string)
      case msg {
        "ready" -> ready_resolve(Nil)
        _ -> echo_resolve(msg)
      }
      Nil
    }
  }

  let assert Ok(w1) =
    worker.from_module("gossamer/broadcast_channel_fixture")
    |> worker.with_on_message(handler(r1_ready, r1_echo))
    |> worker.build

  let assert Ok(w2) =
    worker.from_module("gossamer/broadcast_channel_fixture")
    |> worker.with_on_message(handler(r2_ready, r2_echo))
    |> worker.build

  use _ <- promise.await(promise.await_list([p1_ready, p2_ready]))

  let channel = broadcast_channel.new("test-channel-fanout")
  let assert Ok(_) = broadcast_channel.post_message(channel, "broadcast-data")

  use echoes <- promise.map(promise.await_list([p1_echo, p2_echo]))
  list.length(echoes) |> should.equal(2)
  list.each(echoes, fn(e) { e |> should.equal("broadcast-data") })
  broadcast_channel.close(channel)
  worker.terminate(w1)
  worker.terminate(w2)
}
