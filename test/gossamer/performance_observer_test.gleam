import gleam/javascript/promise
import gleam/list
import gleeunit/should
import gossamer/performance/mark
import gossamer/performance/measure
import gossamer/performance_entry
import gossamer/performance_observer

pub fn supported_entry_types_test() {
  let kinds = performance_observer.supported_entry_types()
  list.contains(kinds, performance_entry.MarkKind) |> should.be_true
  list.contains(kinds, performance_entry.MeasureKind) |> should.be_true
}

pub fn take_records_test() {
  let observer =
    performance_observer.observe(
      [performance_entry.MarkKind],
      fn(_batch, _observer) { Nil },
    )
  let _ = mark.new("test-take-records-mark") |> mark.record()
  let records = performance_observer.take_records(observer)
  performance_observer.disconnect(observer)
  list.is_empty(records) |> should.be_false
}

pub fn observe_mark_test() {
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe(
      [performance_entry.MarkKind],
      fn(batch, _observer) {
        resolve(batch)
        Nil
      },
    )
  let _ = mark.new("test-observer-mark") |> mark.record()
  use batch <- promise.map(p)
  performance_observer.disconnect(observer)
  list.is_empty(batch.entries) |> should.be_false
}

pub fn observe_measure_test() {
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe(
      [performance_entry.MeasureKind],
      fn(batch, _observer) {
        resolve(batch)
        Nil
      },
    )
  let start = mark.new("obs-measure-start") |> mark.record()
  let end = mark.new("obs-measure-end") |> mark.record()
  let _ =
    measure.between(
      "test-observer-measure",
      from: start.start_time,
      to: end.start_time,
    )
    |> measure.record()
  use batch <- promise.map(p)
  performance_observer.disconnect(observer)
  list.is_empty(batch.entries) |> should.be_false
}

pub fn observe_buffered_test() {
  let _ = mark.new("test-buffered-pre") |> mark.record()
  let #(p, resolve) = promise.start()
  let observer =
    performance_observer.observe_buffered(
      performance_entry.MarkKind,
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
    performance_observer.observe(
      [performance_entry.MarkKind],
      fn(batch, _observer) {
        resolve(batch)
        Nil
      },
    )
  let _ = mark.new("test-batch-dropped") |> mark.record()
  use batch <- promise.map(p)
  performance_observer.disconnect(observer)
  batch.dropped |> should.equal(0)
}
