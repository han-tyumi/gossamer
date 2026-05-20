import gleam/javascript/promise
import gleam/list
import gleeunit/should
import gossamer/performance
import gossamer/performance_entry
import gossamer/performance_observer

pub fn supported_entry_types_test() {
  let kinds = performance_observer.supported_entry_types()
  list.contains(kinds, performance_entry.Mark) |> should.be_true
  list.contains(kinds, performance_entry.Measure) |> should.be_true
}

pub fn take_records_test() {
  let observer =
    performance_observer.observe(
      [performance_entry.Mark],
      fn(_batch, _observer) { Nil },
    )
  let _ = performance.mark("test-take-records-mark")
  let records = performance_observer.take_records(observer)
  performance_observer.disconnect(observer)
  list.is_empty(records) |> should.be_false
}

pub fn observe_mark_test() {
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe([performance_entry.Mark], fn(batch, _observer) {
      resolve(batch)
      Nil
    })
  let _ = performance.mark("test-observer-mark")
  use batch <- promise.map(p)
  performance_observer.disconnect(observer)
  list.is_empty(batch.entries) |> should.be_false
}

pub fn observe_measure_test() {
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe(
      [performance_entry.Measure],
      fn(batch, _observer) {
        resolve(batch)
        Nil
      },
    )
  let _ = performance.mark("obs-measure-start")
  let _ = performance.mark("obs-measure-end")
  let assert Ok(_) =
    performance.measure(
      "test-observer-measure",
      from: "obs-measure-start",
      to: "obs-measure-end",
    )
  use batch <- promise.map(p)
  performance_observer.disconnect(observer)
  list.is_empty(batch.entries) |> should.be_false
}

pub fn observe_buffered_test() {
  let _ = performance.mark("test-buffered-pre")
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe_buffered(
      performance_entry.Mark,
      fn(batch, _observer) {
        resolve(batch)
        Nil
      },
    )
  use batch <- promise.map(p)
  performance_observer.disconnect(observer)
  list.is_empty(batch.entries) |> should.be_false
}

pub fn batch_dropped_default_test() {
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe([performance_entry.Mark], fn(batch, _observer) {
      resolve(batch)
      Nil
    })
  let _ = performance.mark("test-batch-dropped")
  use batch <- promise.map(p)
  performance_observer.disconnect(observer)
  batch.dropped |> should.equal(0)
}
