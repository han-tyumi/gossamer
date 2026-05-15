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
  let info = performance_entry.info(performance.mark("test-mark"))
  info.name |> should.equal("test-mark")
  info.entry_type |> should.equal("mark")
  duration.compare(info.start_time, duration.seconds(0))
  |> should.not_equal(order.Lt)
  info.duration |> should.equal(duration.seconds(0))
  performance.clear_marks()
}

pub fn measure_test() {
  let _ = performance.mark("measure-start")
  let _ = performance.mark("measure-end")
  let assert Ok(entry) =
    performance.measure("test-measure", "measure-start", "measure-end")
  let info = performance_entry.info(entry)
  info.name |> should.equal("test-measure")
  info.entry_type |> should.equal("measure")
  duration.compare(info.duration, duration.seconds(0))
  |> should.not_equal(order.Lt)
  performance.clear_marks()
  performance.clear_measures()
}

pub fn measure_invalid_test() {
  performance.measure("bad", "nonexistent-start", "nonexistent-end")
  |> should.be_error
}

pub fn get_entries_test() {
  performance.clear_marks()
  performance.clear_measures()
  let _ = performance.mark("entries-mark")
  let entries = performance.get_entries()
  should.be_true(list.length(entries) >= 1)
  performance.clear_marks()
}

pub fn get_entries_by_name_test() {
  performance.clear_marks()
  let _ = performance.mark("named-mark")
  let entries = performance.get_entries_by_name("named-mark")
  should.equal(list.length(entries), 1)
  performance.clear_marks()
}

pub fn get_entries_by_type_test() {
  performance.clear_marks()
  let _ = performance.mark("typed-mark")
  let entries = performance.get_entries_by_type("mark")
  should.be_true(list.length(entries) >= 1)
  performance.clear_marks()
}

pub fn clear_marks_test() {
  let _ = performance.mark("to-clear")
  performance.clear_marks()
  let entries = performance.get_entries_by_name("to-clear")
  should.equal(list.length(entries), 0)
}

pub fn clear_measures_test() {
  let _ = performance.mark("cm-start")
  let _ = performance.mark("cm-end")
  let assert Ok(_) = performance.measure("to-clear-m", "cm-start", "cm-end")
  performance.clear_measures()
  let entries = performance.get_entries_by_name("to-clear-m")
  should.equal(list.length(entries), 0)
  performance.clear_marks()
}

pub fn performance_entry_detail_test() {
  let entry = performance.mark("detail-mark")
  performance_entry.info(entry).detail |> should.equal(option.None)
  performance.clear_marks()
}

pub fn performance_entry_to_json_test() {
  let entry = performance.mark("json-mark")
  let _json = performance_entry.to_json(entry)
  performance.clear_marks()
}

pub fn performance_to_json_test() {
  let _json = performance.to_json()
}
