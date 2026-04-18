import gleam/dynamic/decode
import gleeunit/should
import gossamer/custom_event
import gossamer/event
import gossamer/event_target
import gossamer/promise

pub fn new_test() {
  let ev = custom_event.new("custom")
  ev |> custom_event.to_event |> event.type_ |> should.equal("custom")
}

pub fn new_with_detail_test() {
  let ev = custom_event.new_with_detail("custom", "hello")
  let assert Ok(detail) = custom_event.detail(ev)
  let assert Ok(value) = decode.run(detail, decode.string)
  value |> should.equal("hello")
}

pub fn detail_none_test() {
  let ev = custom_event.new("custom")
  custom_event.detail(ev) |> should.be_error()
}

pub fn detail_int_test() {
  let ev = custom_event.new_with_detail("custom", 42)
  let assert Ok(detail) = custom_event.detail(ev)
  let assert Ok(value) = decode.run(detail, decode.int)
  value |> should.equal(42)
}

pub fn to_event_properties_test() {
  let ev = custom_event.new("test")
  let base = custom_event.to_event(ev)
  event.type_(base) |> should.equal("test")
  event.is_bubbles(base) |> should.be_false()
  event.is_cancelable(base) |> should.be_false()
}

pub fn dispatch_custom_event_test() {
  let resolvers = promise.with_resolvers()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "greet", run: fn(_) {
    resolvers.resolve("received")
    Nil
  })

  let ev = custom_event.new_with_detail("greet", "world")
  let _ =
    event_target.dispatch_event(on: target, event: custom_event.to_event(ev))

  use value <- promise.then(resolvers.promise)
  value |> should.equal(Ok("received"))
  promise.resolve(Nil)
}
