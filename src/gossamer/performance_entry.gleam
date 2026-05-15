//// A single entry on the performance timeline — a mark, a measure, or
//// another runtime-recorded metric. Returned by
//// [`gossamer/performance.mark`](../performance.html#mark),
//// [`measure`](../performance.html#measure), and the various
//// `get_entries_*` queries.

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gleam/time/duration.{type Duration}

/// A single performance metric produced by the Performance API.
///
/// See [PerformanceEntry](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry) on MDN.
///
@external(javascript, "./performance_entry.type.ts", "PerformanceEntry$")
pub type PerformanceEntry

/// A snapshot of a [`PerformanceEntry`](#PerformanceEntry)'s
/// recorded fields, returned by [`info`](#info). All fields are
/// immutable once the runtime has recorded the entry.
///
pub type Info {
  Info(
    /// The entry's name (the `name` argument passed to `mark` or
    /// `measure`).
    name: String,
    /// The entry's type as a string (e.g., `"mark"`, `"measure"`,
    /// `"resource"`).
    entry_type: String,
    /// The high-resolution elapsed time since
    /// `performance.time_origin` at which the entry was recorded.
    start_time: Duration,
    /// The high-resolution duration of the entry. For `mark` entries
    /// this is always zero; for `measure` entries it is the elapsed
    /// time between the start and end marks.
    duration: Duration,
    /// Extra data associated with the entry, or `None` if none was
    /// provided.
    detail: Option(Dynamic),
  )
}

/// A snapshot of the entry's name, type, start time, duration, and
/// optional detail payload.
///
@external(javascript, "./performance_entry.ffi.mjs", "info")
pub fn info(entry: PerformanceEntry) -> Info

/// Returns a JSON-serializable snapshot of the entry as a `Dynamic`.
/// Pass to `gleam/json.encode_dynamic` (or any dynamic-aware
/// serializer) to produce a JSON string, or decode with
/// `gleam/dynamic/decode` to extract specific fields.
///
@external(javascript, "./performance_entry.ffi.mjs", "to_json")
pub fn to_json(entry: PerformanceEntry) -> Dynamic
