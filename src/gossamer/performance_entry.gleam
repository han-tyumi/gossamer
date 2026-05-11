import gleam/dynamic.{type Dynamic}
import gleam/time/duration.{type Duration}

/// A single performance metric produced by the Performance API.
///
/// See [PerformanceEntry](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry) on MDN.
///
@external(javascript, "./performance_entry.type.ts", "PerformanceEntry$")
pub type PerformanceEntry

@external(javascript, "./performance_entry.ffi.mjs", "name")
pub fn name(of entry: PerformanceEntry) -> String

@external(javascript, "./performance_entry.ffi.mjs", "entry_type")
pub fn entry_type(of entry: PerformanceEntry) -> String

/// The high-resolution elapsed time since `performance.time_origin` at
/// which the entry was recorded.
///
@external(javascript, "./performance_entry.ffi.mjs", "start_time")
pub fn start_time(of entry: PerformanceEntry) -> Duration

/// The high-resolution duration of the entry. For `mark` entries this
/// is always zero; for `measure` entries it is the elapsed time between
/// the start and end marks.
///
@external(javascript, "./performance_entry.ffi.mjs", "duration")
pub fn duration(of entry: PerformanceEntry) -> Duration

/// Extra data associated with the entry, or `Error(Nil)` if none was
/// provided.
///
@external(javascript, "./performance_entry.ffi.mjs", "detail")
pub fn detail(of entry: PerformanceEntry) -> Result(Dynamic, Nil)

@external(javascript, "./performance_entry.ffi.mjs", "to_json")
pub fn to_json(entry: PerformanceEntry) -> Dynamic
