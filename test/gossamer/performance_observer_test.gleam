import gleam/javascript/promise
import gleam/list
import gleeunit/should
import gossamer/performance
import gossamer/performance_observer

pub fn supported_entry_types_test() {
  let types = performance_observer.supported_entry_types()
  list.contains(types, "mark") |> should.be_true
  list.contains(types, "measure") |> should.be_true
}

pub fn take_records_test() {
  let observer = performance_observer.observe(["mark"], fn(_) { Nil })
  let _ = performance.mark("test-take-records-mark")
  let records = performance_observer.take_records(observer)
  performance_observer.disconnect(observer)
  list.is_empty(records) |> should.be_false
}

pub fn observe_mark_test() {
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe(["mark"], fn(entries) {
      resolve(entries)
      Nil
    })
  let _ = performance.mark("test-observer-mark")
  use entries <- promise.map(p)
  performance_observer.disconnect(observer)
  list.is_empty(entries) |> should.be_false
}

pub fn observe_measure_test() {
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe(["measure"], fn(entries) {
      resolve(entries)
      Nil
    })
  let _ = performance.mark("obs-measure-start")
  let _ = performance.mark("obs-measure-end")
  let assert Ok(_) =
    performance.measure(
      "test-observer-measure",
      from: "obs-measure-start",
      to: "obs-measure-end",
    )
  use entries <- promise.map(p)
  performance_observer.disconnect(observer)
  list.is_empty(entries) |> should.be_false
}
