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

/// The kind of entry a performance timeline records. Maps the
/// JavaScript `entryType` string set; runtimes only emit a subset
/// (Deno produces `Mark` and `Measure`; Bun adds `Resource`; Node
/// adds the full set including `Dns`, `Gc`, `Http`, etc.).
///
pub type EntryType {
  /// `performance.mark`-recorded entries.
  Mark

  /// `performance.measure`-recorded entries.
  Measure

  /// Resource-loading entries (Node, Bun, browsers).
  Resource

  /// Document-navigation entries (browsers).
  Navigation

  /// Paint timing entries (browsers).
  Paint

  /// Long-task entries (browsers).
  LongTask

  /// Generic event-timing entries (browsers).
  Event

  /// First-input delay entries (browsers).
  FirstInput

  /// Largest contentful paint entries (browsers).
  LargestContentfulPaint

  /// Layout-shift entries (browsers).
  LayoutShift

  /// Task-attribution entries (browsers).
  TaskAttribution

  /// Visibility-state-change entries (browsers).
  VisibilityState

  /// Element-timing entries (browsers).
  Element

  /// Back-forward cache restoration entries (browsers).
  BackForwardCacheRestoration

  /// DNS-lookup entries (Node).
  Dns

  /// Function-call entries (Node).
  Function

  /// Garbage-collection entries (Node).
  Gc

  /// HTTP-request entries (Node).
  Http

  /// HTTP/2 stream entries (Node).
  Http2

  /// Network-socket entries (Node).
  Net

  /// Any other entry-type string the runtime exposes that this
  /// binding doesn't recognize.
  Other(String)
}

/// A snapshot of a [`PerformanceEntry`](#PerformanceEntry)'s
/// recorded fields, returned by [`info`](#info). All fields are
/// immutable once the runtime has recorded the entry.
///
pub type Info {
  Info(
    /// The entry's name (the `name` argument passed to `mark` or
    /// `measure`).
    name: String,
    /// The entry's category.
    entry_type: EntryType,
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
