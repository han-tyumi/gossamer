//// Access to the runtime's high-resolution performance timeline —
//// monotonic timestamps, named marks, and span measurements.
////
//// Recording lives in the per-kind submodules:
////
//// - [`gossamer/performance/mark`](./performance/mark.html) — record
////   marks (point-in-time events).
//// - [`gossamer/performance/measure`](./performance/measure.html) —
////   record measures (span between two timestamps).
////
//// See [Performance](https://developer.mozilla.org/en-US/docs/Web/API/Performance) on MDN.

import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}
import gossamer/performance_entry.{type Kind, type PerformanceEntry}

/// Returns the high-resolution elapsed time since
/// [`time_origin`](#time_origin), monotonically non-decreasing within
/// the execution context. Pair with [`time_origin`](#time_origin) to
/// recover an absolute `Timestamp`, or subtract two [`now`](#now)
/// values via `duration.difference` to measure elapsed time.
///
@external(javascript, "./performance.ffi.mjs", "now")
pub fn now() -> Duration

/// Returns the time origin — the absolute reference point all
/// performance timestamps are measured from.
///
@external(javascript, "./performance.ffi.mjs", "time_origin")
pub fn time_origin() -> Timestamp

/// Removes all `mark` entries from the performance timeline.
///
@external(javascript, "./performance.ffi.mjs", "clear_marks")
pub fn clear_marks() -> Nil

/// Removes the mark entries whose name matches `name` from the
/// performance timeline.
///
@external(javascript, "./performance.ffi.mjs", "clear_marks_by_name")
pub fn clear_marks_by_name(name: String) -> Nil

/// Removes all `measure` entries from the performance timeline.
///
@external(javascript, "./performance.ffi.mjs", "clear_measures")
pub fn clear_measures() -> Nil

/// Removes the measure entries whose name matches `name` from the
/// performance timeline.
///
@external(javascript, "./performance.ffi.mjs", "clear_measures_by_name")
pub fn clear_measures_by_name(name: String) -> Nil

/// Returns every entry on the performance timeline.
///
@external(javascript, "./performance.ffi.mjs", "entries")
pub fn entries() -> List(PerformanceEntry)

/// Returns the entries on the performance timeline whose name matches
/// `name`.
///
@external(javascript, "./performance.ffi.mjs", "entries_by_name")
pub fn entries_by_name(name: String) -> List(PerformanceEntry)

/// Returns the entries on the performance timeline whose kind matches
/// `kind`. For kinds with a dedicated submodule, prefer the typed
/// helper (e.g.,
/// [`gossamer/performance/mark.entries`](./performance/mark.html#entries))
/// which returns the typed record directly.
///
@external(javascript, "./performance.ffi.mjs", "entries_by_kind")
pub fn entries_by_kind(kind: Kind) -> List(PerformanceEntry)

@internal
pub fn clamp_to_zero(d: Duration) -> Duration {
  let #(seconds, _) = duration.to_seconds_and_nanoseconds(d)
  case seconds < 0 {
    True -> duration.seconds(0)
    False -> d
  }
}
