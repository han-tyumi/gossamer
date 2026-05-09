import gleam/javascript/promise
import gleeunit/should
import gossamer/event
import gossamer/event_target

pub fn new_test() {
  let ev = event.new("click")
  event.type_(ev) |> should.equal("click")
}

pub fn new_with_test() {
  let ev =
    event.new_with("custom", [
      event.Bubbles(True),
      event.Cancelable(True),
      event.Composed(True),
    ])
  event.type_(ev) |> should.equal("custom")
  event.is_bubbles(ev) |> should.be_true()
  event.is_cancelable(ev) |> should.be_true()
  event.is_composed(ev) |> should.be_true()
}

pub fn default_init_test() {
  let ev = event.new("test")
  event.is_bubbles(ev) |> should.be_false()
  event.is_cancelable(ev) |> should.be_false()
  event.is_composed(ev) |> should.be_false()
}

pub fn target_undispatched_test() {
  let ev = event.new("test")
  event.target(ev) |> should.be_error()
}

pub fn current_target_undispatched_test() {
  let ev = event.new("test")
  event.current_target(ev) |> should.be_error()
}

pub fn event_phase_test() {
  let ev = event.new("test")
  event.event_phase(ev) |> should.equal(event.None)
}

pub fn time_stamp_test() {
  let ev = event.new("test")
  let stamp = event.time_stamp(ev)
  should.be_true(stamp >=. 0.0)
}

pub fn is_trusted_test() {
  let ev = event.new("test")
  event.is_trusted(ev) |> should.be_false()
}

pub fn prevent_default_test() {
  let ev = event.new_with("test", [event.Cancelable(True)])
  event.is_default_prevented(ev) |> should.be_false()
  event.prevent_default(ev)
  event.is_default_prevented(ev) |> should.be_true()
}

pub fn stop_propagation_test() {
  let ev = event.new("test")
  event.stop_propagation(ev)
}

pub fn stop_immediate_propagation_test() {
  let ev = event.new("test")
  event.stop_immediate_propagation(ev)
}

pub fn composed_path_undispatched_test() {
  let ev = event.new("test")
  event.composed_path(ev) |> should.equal([])
}

pub fn event_target_new_test() {
  let target = event_target.new()
  let ev = event.new("test")
  event_target.dispatch_event(on: target, event: ev) |> should.equal(Ok(True))
}

pub fn add_event_listener_test() {
  let #(p, resolve) = promise.start()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "ping", run: fn(ev) {
    resolve(event.type_(ev))
    Nil
  })

  let _ = event_target.dispatch_event(on: target, event: event.new("ping"))

  use value <- promise.map(p)
  value |> should.equal("ping")
}

pub fn multiple_listeners_test() {
  let #(p1, resolve1) = promise.start()
  let #(p2, resolve2) = promise.start()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "test", run: fn(_) {
    resolve1("first")
    Nil
  })

  event_target.add_event_listener(to: target, on: "test", run: fn(_) {
    resolve2("second")
    Nil
  })

  let _ = event_target.dispatch_event(on: target, event: event.new("test"))

  use value1 <- promise.await(p1)
  value1 |> should.equal("first")

  use value2 <- promise.map(p2)
  value2 |> should.equal("second")
}

pub fn remove_event_listener_test() {
  let target = event_target.new()
  let #(_p, resolve) = promise.start()

  let handler = fn(_ev) {
    resolve("called")
    Nil
  }

  event_target.add_event_listener(to: target, on: "test", run: handler)
  event_target.remove_event_listener(
    from: target,
    on: "test",
    listener: handler,
  )

  // Dispatch should not trigger the removed handler
  event_target.dispatch_event(on: target, event: event.new("test"))
  |> should.equal(Ok(True))
}

pub fn dispatch_event_cancelable_test() {
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "cancel", run: fn(ev) {
    event.prevent_default(ev)
    Nil
  })

  let ev = event.new_with("cancel", [event.Cancelable(True)])
  let result = event_target.dispatch_event(on: target, event: ev)

  // dispatch_event returns False when preventDefault was called
  result |> should.equal(Ok(False))
}

pub fn once_option_test() {
  let #(p, resolve) = promise.start()
  let target = event_target.new()

  event_target.add_event_listener_with(
    to: target,
    on: "once",
    run: fn(_) {
      resolve(1)
      Nil
    },
    with: [event_target.Once(True)],
  )

  // First dispatch triggers the listener
  let _ = event_target.dispatch_event(on: target, event: event.new("once"))

  // Second dispatch should not trigger (listener was auto-removed)
  let _ = event_target.dispatch_event(on: target, event: event.new("once"))

  use count <- promise.map(p)
  count |> should.equal(1)
}

pub fn target_in_listener_test() {
  let #(p, resolve) = promise.start()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "test", run: fn(ev) {
    let has_target = case event.target(ev) {
      Ok(_) -> True
      Error(_) -> False
    }
    resolve(has_target)
    Nil
  })

  let _ = event_target.dispatch_event(on: target, event: event.new("test"))

  use has_target <- promise.map(p)
  has_target |> should.equal(True)
}

pub fn event_phase_in_listener_test() {
  let #(p, resolve) = promise.start()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "test", run: fn(ev) {
    resolve(event.event_phase(ev))
    Nil
  })

  let _ = event_target.dispatch_event(on: target, event: event.new("test"))

  use phase <- promise.map(p)
  phase |> should.equal(event.AtTarget)
}
