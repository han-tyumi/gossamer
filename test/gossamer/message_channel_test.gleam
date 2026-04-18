import gleam/dynamic/decode
import gleeunit/should
import gossamer/message_channel
import gossamer/message_event
import gossamer/message_port
import gossamer/promise

pub fn new_test() {
  let channel = message_channel.new()
  let _port1 = message_channel.port1(channel)
  let _port2 = message_channel.port2(channel)
}

pub fn post_message_test() {
  let channel = message_channel.new()
  let port1 = message_channel.port1(channel)
  let port2 = message_channel.port2(channel)

  let resolvers = promise.with_resolvers()

  message_port.on_message(port2, fn(event) {
    let assert Ok(value) = decode.run(message_event.data(event), decode.string)
    resolvers.resolve(value)
    Nil
  })

  let assert Ok(_) = message_port.post_message(port1, "hello from port1")

  use value <- promise.then(resolvers.promise)
  should.equal(value, Ok("hello from port1"))
  message_port.close(port1)
  message_port.close(port2)
  promise.resolve(Nil)
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

pub fn message_event_properties_test() {
  let channel = message_channel.new()
  let port1 = message_channel.port1(channel)
  let port2 = message_channel.port2(channel)

  let resolvers = promise.with_resolvers()

  message_port.on_message(port2, fn(event) {
    let _origin = message_event.origin(event)
    let _last_event_id = message_event.last_event_id(event)
    resolvers.resolve(Nil)
    Nil
  })

  let assert Ok(_) = message_port.post_message(port1, "test")

  use _ <- promise.then(resolvers.promise)
  message_port.close(port1)
  message_port.close(port2)
  promise.resolve(Nil)
}

pub fn on_message_error_test() {
  let channel = message_channel.new()
  let port1 = message_channel.port1(channel)
  message_port.on_message_error(port1, fn(_event) { Nil })
  message_port.close(port1)
}
