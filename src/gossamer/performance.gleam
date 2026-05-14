//// Access to the runtime's high-resolution performance timeline —
//// monotonic timestamps, named marks, and span measurements.
////
//// See [Performance](https://developer.mozilla.org/en-US/docs/Web/API/Performance) on MDN.

import gleam/dynamic.{type Dynamic}
import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}
import gossamer/performance_entry.{type PerformanceEntry}

/// Returns the high-resolution elapsed time since
/// [`time_origin`](#time_origin). Pair with `time_origin` to recover
/// an absolute `Timestamp`, or subtract two `now()` values via
/// `duration.difference` to measure elapsed time.
///
@external(javascript, "./performance.ffi.mjs", "now")
pub fn now() -> Duration

/// Returns the time origin — the absolute reference point all
/// performance timestamps are measured from.
///
@external(javascript, "./performance.ffi.mjs", "time_origin")
pub fn time_origin() -> Timestamp

/// Records a performance mark with `name` at the current time.
///
@external(javascript, "./performance.ffi.mjs", "mark")
pub fn mark(name: String) -> PerformanceEntry

/// Records a measurement between two previously-recorded marks. Returns
/// an error if either `start_mark` or `end_mark` doesn't exist.
///
@external(javascript, "./performance.ffi.mjs", "measure")
pub fn measure(
  name: String,
  from start_mark: String,
  to end_mark: String,
) -> Result(PerformanceEntry, Nil)

/// Removes all `mark` entries from the performance timeline.
///
@external(javascript, "./performance.ffi.mjs", "clear_marks")
pub fn clear_marks() -> Nil

/// Removes all `measure` entries from the performance timeline.
///
@external(javascript, "./performance.ffi.mjs", "clear_measures")
pub fn clear_measures() -> Nil

/// Returns every entry on the performance timeline.
///
@external(javascript, "./performance.ffi.mjs", "get_entries")
pub fn get_entries() -> List(PerformanceEntry)

/// Returns the entries on the performance timeline whose name matches
/// `name`.
///
@external(javascript, "./performance.ffi.mjs", "get_entries_by_name")
pub fn get_entries_by_name(name: String) -> List(PerformanceEntry)

/// Returns the entries on the performance timeline whose type matches
/// `entry_type` (e.g., `"mark"`, `"measure"`).
///
@external(javascript, "./performance.ffi.mjs", "get_entries_by_type")
pub fn get_entries_by_type(entry_type: String) -> List(PerformanceEntry)

/// Returns a JSON-serializable snapshot of the performance object as
/// a `Dynamic`. Pass to `gleam/json.encode_dynamic` (or any
/// dynamic-aware serializer) to produce a JSON string, or decode with
/// `gleam/dynamic/decode` to extract specific fields.
///
@external(javascript, "./performance.ffi.mjs", "to_json")
pub fn to_json() -> Dynamic
