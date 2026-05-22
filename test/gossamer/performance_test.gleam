import gleam/dynamic
import gleam/list
import gleam/option
import gleam/order
import gleam/time/duration
import gleam/time/timestamp
import gleeunit/should
import gossamer/performance
import gossamer/performance/mark
import gossamer/performance/measure
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
  let m = mark.new("test-mark") |> mark.record()
  m.name |> should.equal("test-mark")
  duration.compare(m.start_time, duration.seconds(0))
  |> should.not_equal(order.Lt)
  m.detail |> should.equal(option.None)
  performance.clear_marks()
}

pub fn mark_at_clamps_negative_test() {
  let m = mark.at("clamp-mark", duration.milliseconds(-50)) |> mark.record()
  m.start_time |> should.equal(duration.seconds(0))
  performance.clear_marks()
}

pub fn mark_with_detail_test() {
  let m =
    mark.new("detailed-mark")
    |> mark.set_detail(dynamic.string("hello"))
    |> mark.record()
  m.detail |> option.is_some |> should.be_true
  performance.clear_marks()
}

pub fn measure_test() {
  let start = mark.new("measure-start") |> mark.record()
  let end = mark.new("measure-end") |> mark.record()
  let m =
    measure.between("test-measure", from: start.start_time, to: end.start_time)
    |> measure.record()
  m.name |> should.equal("test-measure")
  duration.compare(m.duration, duration.seconds(0))
  |> should.not_equal(order.Lt)
  performance.clear_marks()
  performance.clear_measures()
}

pub fn measure_between_marks_test() {
  performance.clear_marks()
  performance.clear_measures()
  let _ = mark.new("start-anchor") |> mark.record()
  let _ = mark.new("end-anchor") |> mark.record()
  let assert Ok(m) =
    measure.between_marks(
      "span-by-marks",
      from: "start-anchor",
      to: "end-anchor",
    )
  m |> measure.record()
  measure.entries_by_name("span-by-marks")
  |> list.length
  |> should.equal(1)
  performance.clear_marks()
  performance.clear_measures()
}

pub fn measure_between_marks_missing_test() {
  performance.clear_marks()
  measure.between_marks("span", from: "no-such-mark", to: "also-missing")
  |> should.be_error
  performance.clear_marks()
}

pub fn measure_clamps_inverted_endpoints_test() {
  let m =
    measure.between(
      "test-measure-inverted",
      from: duration.milliseconds(100),
      to: duration.milliseconds(50),
    )
  m.duration |> should.equal(duration.seconds(0))
}

pub fn measure_clamps_negative_test() {
  let m =
    measure.between(
      "test-measure-clamp",
      from: duration.milliseconds(-50),
      to: duration.milliseconds(0),
    )
    |> measure.record()
  m.start_time |> should.equal(duration.seconds(0))
  performance.clear_measures()
}

pub fn mark_entries_test() {
  performance.clear_marks()
  let _ = mark.new("entry-1") |> mark.record()
  let _ = mark.new("entry-2") |> mark.record()
  mark.entries() |> list.length |> should.equal(2)
  performance.clear_marks()
}

pub fn measure_entries_test() {
  performance.clear_marks()
  performance.clear_measures()
  let start = mark.new("s") |> mark.record()
  let end = mark.new("e") |> mark.record()
  let _ =
    measure.between("m1", from: start.start_time, to: end.start_time)
    |> measure.record()
  let _ =
    measure.between("m2", from: start.start_time, to: end.start_time)
    |> measure.record()
  measure.entries() |> list.length |> should.equal(2)
  performance.clear_marks()
  performance.clear_measures()
}

pub fn from_entry_mark_test() {
  let recorded = mark.new("from-entry") |> mark.record()
  let entries = performance.entries_by_name("from-entry")
  let assert [entry] = entries
  let assert Ok(projected) = mark.from_entry(entry)
  projected.name |> should.equal(recorded.name)
  performance.clear_marks()
}

pub fn from_entry_wrong_kind_test() {
  let start = mark.new("wk-s") |> mark.record()
  let end = mark.new("wk-e") |> mark.record()
  let _ =
    measure.between("wk-m", from: start.start_time, to: end.start_time)
    |> measure.record()
  let measure_entries = performance.entries_by_name("wk-m")
  let assert [entry] = measure_entries
  mark.from_entry(entry) |> should.be_error
  performance.clear_marks()
  performance.clear_measures()
}

pub fn entries_test() {
  performance.clear_marks()
  performance.clear_measures()
  let _ = mark.new("entries-mark") |> mark.record()
  let entries = performance.entries()
  should.be_true(list.length(entries) >= 1)
  performance.clear_marks()
}

pub fn entries_by_name_test() {
  performance.clear_marks()
  let _ = mark.new("named-mark") |> mark.record()
  let entries = performance.entries_by_name("named-mark")
  should.equal(list.length(entries), 1)
  performance.clear_marks()
}

pub fn entries_by_kind_test() {
  performance.clear_marks()
  let _ = mark.new("typed-mark") |> mark.record()
  let entries = performance.entries_by_kind(performance_entry.MarkKind)
  should.be_true(list.length(entries) >= 1)
  performance.clear_marks()
}

pub fn clear_marks_test() {
  let _ = mark.new("to-clear") |> mark.record()
  performance.clear_marks()
  let entries = performance.entries_by_name("to-clear")
  should.equal(list.length(entries), 0)
}

pub fn clear_marks_by_name_test() {
  let _ = mark.new("keep") |> mark.record()
  let _ = mark.new("drop") |> mark.record()
  performance.clear_marks_by_name("drop")
  performance.entries_by_name("drop") |> list.length |> should.equal(0)
  performance.entries_by_name("keep") |> list.length |> should.equal(1)
  performance.clear_marks()
}

pub fn clear_measures_test() {
  let start = mark.new("cm-start") |> mark.record()
  let end = mark.new("cm-end") |> mark.record()
  let _ =
    measure.between("to-clear-m", from: start.start_time, to: end.start_time)
    |> measure.record()
  performance.clear_measures()
  let entries = performance.entries_by_name("to-clear-m")
  should.equal(list.length(entries), 0)
  performance.clear_marks()
}

pub fn clear_measures_by_name_test() {
  let start = mark.new("cmm-start") |> mark.record()
  let end = mark.new("cmm-end") |> mark.record()
  let _ =
    measure.between("keep-m", from: start.start_time, to: end.start_time)
    |> measure.record()
  let _ =
    measure.between("drop-m", from: start.start_time, to: end.start_time)
    |> measure.record()
  performance.clear_measures_by_name("drop-m")
  performance.entries_by_name("drop-m") |> list.length |> should.equal(0)
  performance.entries_by_name("keep-m") |> list.length |> should.equal(1)
  performance.clear_marks()
  performance.clear_measures()
}

pub fn entry_shared_field_access_test() {
  let m = mark.new("shared-field") |> mark.record()
  let entries = performance.entries_by_name("shared-field")
  let assert [entry] = entries
  entry.name |> should.equal(m.name)
  duration.compare(entry.start_time, duration.seconds(0))
  |> should.not_equal(order.Lt)
  performance.clear_marks()
}
