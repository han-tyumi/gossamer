import gleam/list
import gleam/option
import gleam/order
import gleam/time/duration
import gleam/time/timestamp
import gleeunit/should
import gossamer/performance
import gossamer/performance_entry

pub fn now_test() {
  let elapsed = performance.now()
  duration.compare(elapsed, duration.seconds(0))
  |> should.not_equal(order.Lt)
}

pub fn time_origin_test() {
  let origin = performance.time_origin()
  timestamp.compare(origin, timestamp.from_unix_seconds(0))
  |> should.equal(order.Gt)
}

pub fn mark_test() {
  let entry = performance.mark("test-mark")
  entry.kind |> should.equal(performance_entry.Mark)
  entry.name |> should.equal("test-mark")
  duration.compare(entry.start_time, duration.seconds(0))
  |> should.not_equal(order.Lt)
  entry.duration |> should.equal(duration.seconds(0))
  performance.clear_marks()
}

pub fn measure_test() {
  let _ = performance.mark("measure-start")
  let _ = performance.mark("measure-end")
  let assert Ok(entry) =
    performance.measure("test-measure", "measure-start", "measure-end")
  entry.kind |> should.equal(performance_entry.Measure)
  entry.name |> should.equal("test-measure")
  duration.compare(entry.duration, duration.seconds(0))
  |> should.not_equal(order.Lt)
  performance.clear_marks()
  performance.clear_measures()
}

pub fn measure_invalid_test() {
  performance.measure("bad", "nonexistent-start", "nonexistent-end")
  |> should.be_error
}

pub fn entries_test() {
  performance.clear_marks()
  performance.clear_measures()
  let _ = performance.mark("entries-mark")
  let entries = performance.entries()
  should.be_true(list.length(entries) >= 1)
  performance.clear_marks()
}

pub fn entries_by_name_test() {
  performance.clear_marks()
  let _ = performance.mark("named-mark")
  let entries = performance.entries_by_name("named-mark")
  should.equal(list.length(entries), 1)
  performance.clear_marks()
}

pub fn entries_by_kind_test() {
  performance.clear_marks()
  let _ = performance.mark("typed-mark")
  let entries = performance.entries_by_kind(performance_entry.Mark)
  should.be_true(list.length(entries) >= 1)
  performance.clear_marks()
}

pub fn clear_marks_test() {
  let _ = performance.mark("to-clear")
  performance.clear_marks()
  let entries = performance.entries_by_name("to-clear")
  should.equal(list.length(entries), 0)
}

pub fn clear_measures_test() {
  let _ = performance.mark("cm-start")
  let _ = performance.mark("cm-end")
  let assert Ok(_) = performance.measure("to-clear-m", "cm-start", "cm-end")
  performance.clear_measures()
  let entries = performance.entries_by_name("to-clear-m")
  should.equal(list.length(entries), 0)
  performance.clear_marks()
}

pub fn performance_entry_detail_test() {
  let entry = performance.mark("detail-mark")
  entry.detail |> should.equal(option.None)
  performance.clear_marks()
}
