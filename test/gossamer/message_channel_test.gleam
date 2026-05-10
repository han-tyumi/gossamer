import gleam/dynamic/decode
import gleam/javascript/promise
import gleeunit/should
import gossamer/message_channel
import gossamer/message_port

pub fn new_test() {
  let channel = message_channel.new()
  let _port1 = message_channel.port1(channel)
  let _port2 = message_channel.port2(channel)
}

pub fn post_message_test() {
  let channel = message_channel.new()
  let port1 = message_channel.port1(channel)
  let port2 = message_channel.port2(channel)

  let #(p, resolve) = promise.start()

  message_port.on_message(port2, fn(data) {
    let assert Ok(value) = decode.run(data, decode.string)
    resolve(value)
    Nil
  })

  let assert Ok(_) = message_port.post_message(port1, "hello from port1")

  use value <- promise.map(p)
  should.equal(value, "hello from port1")
  message_port.close(port1)
  message_port.close(port2)
}

pub fn start_test() {
  let channel = message_channel.new()
  let port1 = message_channel.port1(channel)
  message_port.start(port1)
  message_port.close(port1)
}

pub fn close_test() {
  let channel = message_channel.new()
  let port1 = message_channel.port1(channel)
  message_port.close(port1)
}

pub fn on_message_error_test() {
  let channel = message_channel.new()
  let port1 = message_channel.port1(channel)
  message_port.on_message_error(port1, fn() { Nil })
  message_port.close(port1)
}
