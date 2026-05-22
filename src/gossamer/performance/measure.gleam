//// Records a span between two timestamps on the performance
//// timeline. Anchor the span on raw `Duration` values from
//// [`performance.now`](../performance.html#now) or from a previously
//// recorded entry's `start_time`.
////
//// See [Performance.measure](https://developer.mozilla.org/en-US/docs/Web/API/Performance/measure) on MDN.

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option, Some}
import gleam/time/duration.{type Duration}
import gossamer/performance_entry.{type PerformanceEntry, MeasureKind}

/// A measure on the performance timeline.
///
pub type Measure {
  Measure(
    name: String,
    start_time: Duration,
    duration: Duration,
    detail: Option(Dynamic),
  )
}

/// Creates a `Measure` named `name` spanning from `from` to `to` (both
/// relative to
/// [`performance.time_origin`](../performance.html#time_origin)). The
/// `duration` field is computed as `to - from`. Negative inputs are
/// clamped to zero. Pass to [`record`](#record) to write to the
/// timeline.
///
@external(javascript, "./measure.ffi.mjs", "between")
pub fn between(name: String, from from: Duration, to to: Duration) -> Measure

/// Sets the name of the measure.
///
pub fn set_name(measure: Measure, name: String) -> Measure {
  Measure(..measure, name:)
}

/// Sets the start time of the measure relative to
/// [`performance.time_origin`](../performance.html#time_origin).
/// Negative inputs are clamped to zero.
///
pub fn set_start_time(measure: Measure, start_time: Duration) -> Measure {
  Measure(..measure, start_time: clamp(start_time))
}

/// Sets the duration of the measure. Negative inputs are clamped to
/// zero.
///
pub fn set_duration(measure: Measure, duration: Duration) -> Measure {
  Measure(..measure, duration: clamp(duration))
}

/// Sets arbitrary metadata attached to the measure, exposed on the
/// recorded [`Measure`](#Measure)'s `detail` field.
///
pub fn set_detail(measure: Measure, detail: Dynamic) -> Measure {
  Measure(..measure, detail: Some(detail))
}

/// Records the measure on the performance timeline. Returns the
/// [`Measure`](#Measure) unchanged.
///
pub fn record(measure: Measure) -> Measure {
  do_record(measure.name, measure.start_time, measure.duration, measure.detail)
  measure
}

@external(javascript, "./measure.ffi.mjs", "record")
@internal
pub fn do_record(
  name: String,
  start_time: Duration,
  duration: Duration,
  detail: Option(Dynamic),
) -> Nil

/// Returns every measure currently on the performance timeline.
///
@external(javascript, "./measure.ffi.mjs", "entries")
pub fn entries() -> List(Measure)

/// Returns the measures on the performance timeline whose name
/// matches `name`.
///
@external(javascript, "./measure.ffi.mjs", "entries_by_name")
pub fn entries_by_name(name: String) -> List(Measure)

/// Projects a
/// [`PerformanceEntry`](../performance_entry.html#PerformanceEntry)
/// to a [`Measure`](#Measure). Returns `Error(Nil)` if the entry
/// isn't a measure.
///
pub fn from_entry(entry: PerformanceEntry) -> Result(Measure, Nil) {
  case entry.kind {
    MeasureKind -> Ok(do_from_raw(entry.raw))
    _ -> Error(Nil)
  }
}

@external(javascript, "./measure.ffi.mjs", "from_raw")
@internal
pub fn do_from_raw(raw: Dynamic) -> Measure

fn clamp(d: Duration) -> Duration {
  let #(seconds, _) = duration.to_seconds_and_nanoseconds(d)
  case seconds < 0 {
    True -> duration.seconds(0)
    False -> d
  }
}
