//// A single entry on the performance timeline — a mark, a measure, or
//// another runtime-recorded metric. Returned by `performance.mark`,
//// `performance.measure`, and the various `entries_*` queries.

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gleam/time/duration.{type Duration}

/// The kind of entry a performance timeline records. Names match the
/// `entryType` strings defined by the W3C Performance Timeline
/// registry; `Other(value)` carries any runtime-emitted kind this
/// binding doesn't recognize. Runtimes only emit a subset — see
/// `performance_observer.supported_entry_types`.
///
pub type Kind {
  /// User-recorded mark (`performance.mark`).
  Mark

  /// User-recorded measurement (`performance.measure`).
  Measure

  /// Resource-loading timing (fetch on Node, Deno, Bun; browsers also
  /// emit for `<img>`, `<script>`, etc.).
  Resource

  /// Document navigation timing (browsers).
  Navigation

  /// Paint timing — `"first-paint"` and `"first-contentful-paint"`
  /// (browsers).
  Paint

  /// Long-task entries — tasks blocking the main thread for more than
  /// 50ms (browsers).
  LongTask

  /// Event-timing entries — input event latency (browsers).
  Event

  /// First-input delay entries; superseded by `Event` (browsers).
  FirstInput

  /// Largest Contentful Paint — the biggest visible element painted
  /// (browsers, Core Web Vital).
  LargestContentfulPaint

  /// Cumulative Layout Shift — unexpected visual shifts (browsers,
  /// Core Web Vital).
  LayoutShift

  /// Long-task attribution to scripts (browsers).
  TaskAttribution

  /// Page visibility state changes (browsers).
  VisibilityState

  /// Instrumented element rendering timing (browsers).
  Element

  /// Back-forward cache restoration timing (browsers).
  BackForwardCacheRestoration

  /// DNS-lookup timing (Node).
  Dns

  /// Function-call timing from `performance.timerify` (Node).
  Function

  /// Garbage-collection timing (Node).
  Gc

  /// HTTP-request timing for Node's legacy `http` module (Node).
  Http

  /// HTTP/2 stream timing (Node).
  Http2

  /// Network-socket connect timing (Node).
  Net

  /// Any other entry-type string the runtime exposes that this
  /// binding doesn't recognize.
  Other(String)
}

/// A single performance metric produced by the Performance API. The
/// base fields (`name`, `start_time`, `duration`) are populated for
/// every kind; `detail` carries user-supplied or runtime-supplied
/// metadata when the spec defines it (Mark, Measure, and runtime
/// kinds like Gc); `raw` is the original JavaScript entry object,
/// suitable for decoding subclass-specific fields via
/// `gleam/dynamic/decode` or kind-specific helper modules.
///
pub type PerformanceEntry {
  PerformanceEntry(
    /// This entry's kind.
    kind: Kind,
    /// The entry's name. For `Mark` and `Measure`, this is the
    /// user-supplied identifier; for runtime kinds, it varies (e.g.,
    /// the URL for `Resource`).
    name: String,
    /// Elapsed time since `performance.time_origin` at which the
    /// entry was recorded.
    start_time: Duration,
    /// The elapsed time the entry represents, or
    /// `duration.milliseconds(0)` for point-in-time entries.
    duration: Duration,
    /// Extra data attached to the entry when the spec defines a
    /// `detail` field for its kind (`Mark`, `Measure`, `Gc`), or
    /// `None` otherwise.
    detail: Option(Dynamic),
    /// The original JavaScript entry — the full underlying object,
    /// including the base fields exposed above. Use for decoding
    /// subclass-specific fields via `gleam/dynamic/decode`.
    raw: Dynamic,
  )
}
