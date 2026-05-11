import gleam/dynamic.{type Dynamic}
import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}
import gossamer/performance_entry.{type PerformanceEntry}

/// Errors raised by `performance.mark` and `performance.measure`.
pub type PerformanceError {
  /// `name` collides with a read-only attribute on the legacy
  /// `PerformanceTiming` interface. Only browsers (Window contexts)
  /// produce this; Deno, Node, and Bun don't expose `PerformanceTiming`
  /// and skip the check entirely.
  ReservedName

  /// One of the named marks doesn't exist on the performance timeline.
  /// Only `measure` produces this.
  MarkNotFound
}

/// Returns the high-resolution elapsed time since `time_origin`. Pair
/// with `time_origin` to recover an absolute `Timestamp`, or subtract
/// two `now()` values via `duration.difference` to measure elapsed
/// time.
///
@external(javascript, "./performance.ffi.mjs", "now")
pub fn now() -> Duration

/// Returns the time origin — the absolute reference point all
/// performance timestamps are measured from.
///
@external(javascript, "./performance.ffi.mjs", "time_origin")
pub fn time_origin() -> Timestamp

/// Records a performance mark with `name` at the current time. Returns
/// `ReservedName` in browser Window contexts when `name` collides with
/// a `PerformanceTiming` read-only attribute; never fails on Deno,
/// Node, or Bun.
///
@external(javascript, "./performance.ffi.mjs", "mark")
pub fn mark(name: String) -> Result(PerformanceEntry, PerformanceError)

/// Records a measurement between two previously-recorded marks. Returns
/// `MarkNotFound` if either `start_mark` or `end_mark` doesn't exist,
/// or `ReservedName` in browser Window contexts when `name` collides
/// with a `PerformanceTiming` read-only attribute.
///
@external(javascript, "./performance.ffi.mjs", "measure")
pub fn measure(
  name: String,
  from start_mark: String,
  to end_mark: String,
) -> Result(PerformanceEntry, PerformanceError)

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
