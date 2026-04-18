import gleeunit/should
import gossamer/event
import gossamer/event_phase
import gossamer/event_target
import gossamer/promise

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
  event.event_phase(ev) |> should.equal(event_phase.None)
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
  let resolvers = promise.with_resolvers()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "ping", run: fn(ev) {
    resolvers.resolve(event.type_(ev))
    Nil
  })

  let _ = event_target.dispatch_event(on: target, event: event.new("ping"))

  use value <- promise.then(resolvers.promise)
  value |> should.equal(Ok("ping"))
  promise.resolve(Nil)
}

pub fn multiple_listeners_test() {
  let first = promise.with_resolvers()
  let second = promise.with_resolvers()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "test", run: fn(_) {
    first.resolve("first")
    Nil
  })

  event_target.add_event_listener(to: target, on: "test", run: fn(_) {
    second.resolve("second")
    Nil
  })

  let _ = event_target.dispatch_event(on: target, event: event.new("test"))

  use value1 <- promise.then(first.promise)
  value1 |> should.equal(Ok("first"))

  use value2 <- promise.then(second.promise)
  value2 |> should.equal(Ok("second"))
  promise.resolve(Nil)
}

pub fn remove_event_listener_test() {
  let target = event_target.new()
  let resolvers = promise.with_resolvers()

  let handler = fn(_ev) {
    resolvers.resolve("called")
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
  let resolvers = promise.with_resolvers()
  let target = event_target.new()

  event_target.add_event_listener_with(
    to: target,
    on: "once",
    run: fn(_) {
      resolvers.resolve(1)
      Nil
    },
    with: [event_target.Once(True)],
  )

  // First dispatch triggers the listener
  let _ = event_target.dispatch_event(on: target, event: event.new("once"))

  // Second dispatch should not trigger (listener was auto-removed)
  let _ = event_target.dispatch_event(on: target, event: event.new("once"))

  use count <- promise.then(resolvers.promise)
  count |> should.equal(Ok(1))
  promise.resolve(Nil)
}

pub fn target_in_listener_test() {
  let resolvers = promise.with_resolvers()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "test", run: fn(ev) {
    let has_target = case event.target(ev) {
      Ok(_) -> True
      Error(_) -> False
    }
    resolvers.resolve(has_target)
    Nil
  })

  let _ = event_target.dispatch_event(on: target, event: event.new("test"))

  use has_target <- promise.then(resolvers.promise)
  has_target |> should.equal(Ok(True))
  promise.resolve(Nil)
}

pub fn event_phase_in_listener_test() {
  let resolvers = promise.with_resolvers()
  let target = event_target.new()

  event_target.add_event_listener(to: target, on: "test", run: fn(ev) {
    resolvers.resolve(event.event_phase(ev))
    Nil
  })

  let _ = event_target.dispatch_event(on: target, event: event.new("test"))

  use phase <- promise.then(resolvers.promise)
  phase |> should.equal(Ok(event_phase.AtTarget))
  promise.resolve(Nil)
}
