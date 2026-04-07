import gleam/dynamic.{type Dynamic}
import gossamer/performance_entry.{type PerformanceEntry}

@external(javascript, "./performance.ffi.mjs", "now")
pub fn now() -> Float

@external(javascript, "./performance.ffi.mjs", "time_origin")
pub fn time_origin() -> Float

@external(javascript, "./performance.ffi.mjs", "mark")
pub fn mark(name: String) -> Result(PerformanceEntry, String)

@external(javascript, "./performance.ffi.mjs", "measure")
pub fn measure(
  name: String,
  start_mark: String,
  end_mark: String,
) -> Result(PerformanceEntry, String)

@external(javascript, "./performance.ffi.mjs", "clear_marks")
pub fn clear_marks() -> Nil

@external(javascript, "./performance.ffi.mjs", "clear_measures")
pub fn clear_measures() -> Nil

@external(javascript, "./performance.ffi.mjs", "get_entries")
pub fn get_entries() -> List(PerformanceEntry)

@external(javascript, "./performance.ffi.mjs", "get_entries_by_name")
pub fn get_entries_by_name(name: String) -> List(PerformanceEntry)

@external(javascript, "./performance.ffi.mjs", "get_entries_by_type")
pub fn get_entries_by_type(entry_type: String) -> List(PerformanceEntry)

@external(javascript, "./performance.ffi.mjs", "to_json")
pub fn to_json() -> Dynamic
