//// Records a point-in-time event on the performance timeline.
////
//// See [Performance.mark](https://developer.mozilla.org/en-US/docs/Web/API/Performance/mark) on MDN.

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option, None, Some}
import gleam/time/duration.{type Duration}
import gossamer/performance
import gossamer/performance_entry.{type PerformanceEntry, MarkKind}

/// A mark on the performance timeline.
///
pub type Mark {
  Mark(name: String, start_time: Duration, detail: Option(Dynamic))
}

/// Creates a `Mark` named `name` at the current high-resolution time.
/// Pass to [`record`](#record) to write it to the timeline.
///
pub fn new(name: String) -> Mark {
  Mark(name:, start_time: performance.now(), detail: None)
}

/// Creates a `Mark` named `name` at a specific time relative to
/// [`performance.time_origin`](../performance.html#time_origin). Use
/// to backfill a mark for a previously-observed event. Negative
/// inputs are clamped to zero.
///
pub fn at(name: String, time: Duration) -> Mark {
  Mark(name:, start_time: performance.clamp_to_zero(time), detail: None)
}

/// Sets the name of the mark.
///
pub fn set_name(mark: Mark, name: String) -> Mark {
  Mark(..mark, name:)
}

/// Sets the start time of the mark relative to
/// [`performance.time_origin`](../performance.html#time_origin).
/// Negative inputs are clamped to zero.
///
pub fn set_start_time(mark: Mark, start_time: Duration) -> Mark {
  Mark(..mark, start_time: performance.clamp_to_zero(start_time))
}

/// Sets arbitrary metadata attached to the mark, exposed on the
/// recorded [`Mark`](#Mark)'s `detail` field.
///
pub fn set_detail(mark: Mark, detail: Dynamic) -> Mark {
  Mark(..mark, detail: Some(detail))
}

/// Records the mark on the performance timeline. Returns the
/// [`Mark`](#Mark) unchanged.
///
pub fn record(mark: Mark) -> Mark {
  do_record(mark.name, mark.start_time, mark.detail)
  mark
}

@external(javascript, "./mark.ffi.mjs", "record")
@internal
pub fn do_record(
  name: String,
  start_time: Duration,
  detail: Option(Dynamic),
) -> Nil

/// Returns every mark currently on the performance timeline.
///
@external(javascript, "./mark.ffi.mjs", "entries")
pub fn entries() -> List(Mark)

/// Returns the marks on the performance timeline whose name matches
/// `name`.
///
@external(javascript, "./mark.ffi.mjs", "entries_by_name")
pub fn entries_by_name(name: String) -> List(Mark)

/// Projects a
/// [`PerformanceEntry`](../performance_entry.html#PerformanceEntry)
/// to a [`Mark`](#Mark). Returns `Error(Nil)` if the entry isn't a
/// mark.
///
pub fn from_entry(entry: PerformanceEntry) -> Result(Mark, Nil) {
  case entry.kind {
    MarkKind -> Ok(do_from_raw(entry.raw))
    _ -> Error(Nil)
  }
}

@external(javascript, "./mark.ffi.mjs", "from_raw")
@internal
pub fn do_from_raw(raw: Dynamic) -> Mark
