import gleam/list
import gleeunit/should
import gossamer/performance
import gossamer/performance_entry

pub fn now_test() {
  let timestamp = performance.now()
  should.be_true(timestamp >=. 0.0)
}

pub fn time_origin_test() {
  let origin = performance.time_origin()
  should.be_true(origin >. 0.0)
}

pub fn mark_test() {
  let assert Ok(entry) = performance.mark("test-mark")
  performance_entry.name(entry) |> should.equal("test-mark")
  performance_entry.entry_type(entry) |> should.equal("mark")
  should.be_true(performance_entry.start_time(entry) >=. 0.0)
  performance_entry.duration(entry) |> should.equal(0.0)
  performance.clear_marks()
}

pub fn measure_test() {
  let assert Ok(_) = performance.mark("measure-start")
  let assert Ok(_) = performance.mark("measure-end")
  let assert Ok(entry) =
    performance.measure("test-measure", "measure-start", "measure-end")
  performance_entry.name(entry) |> should.equal("test-measure")
  performance_entry.entry_type(entry) |> should.equal("measure")
  should.be_true(performance_entry.duration(entry) >=. 0.0)
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
  let assert Ok(_) = performance.mark("entries-mark")
  let entries = performance.get_entries()
  should.be_true(list.length(entries) >= 1)
  performance.clear_marks()
}

pub fn get_entries_by_name_test() {
  performance.clear_marks()
  let assert Ok(_) = performance.mark("named-mark")
  let entries = performance.get_entries_by_name("named-mark")
  should.equal(list.length(entries), 1)
  performance.clear_marks()
}

pub fn get_entries_by_type_test() {
  performance.clear_marks()
  let assert Ok(_) = performance.mark("typed-mark")
  let entries = performance.get_entries_by_type("mark")
  should.be_true(list.length(entries) >= 1)
  performance.clear_marks()
}

pub fn clear_marks_test() {
  let assert Ok(_) = performance.mark("to-clear")
  performance.clear_marks()
  let entries = performance.get_entries_by_name("to-clear")
  should.equal(list.length(entries), 0)
}

pub fn clear_measures_test() {
  let assert Ok(_) = performance.mark("cm-start")
  let assert Ok(_) = performance.mark("cm-end")
  let assert Ok(_) = performance.measure("to-clear-m", "cm-start", "cm-end")
  performance.clear_measures()
  let entries = performance.get_entries_by_name("to-clear-m")
  should.equal(list.length(entries), 0)
  performance.clear_marks()
}

pub fn performance_entry_detail_test() {
  let assert Ok(entry) = performance.mark("detail-mark")
  performance_entry.detail(entry) |> should.be_error
  performance.clear_marks()
}

pub fn performance_entry_to_json_test() {
  let assert Ok(entry) = performance.mark("json-mark")
  let _json = performance_entry.to_json(entry)
  performance.clear_marks()
}

pub fn performance_to_json_test() {
  let _json = performance.to_json()
}
