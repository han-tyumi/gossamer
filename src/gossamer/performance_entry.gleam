//// A single entry on the performance timeline — a mark, a measure, or
//// another runtime-recorded metric. Returned by
//// [`performance.entries`](./performance.html#entries) and the
//// `entries_*` queries, and delivered to
//// [`performance_observer`](./performance_observer.html) callbacks.
////
//// Each variant carries the spec-defined fields for its kind. The
//// base fields `name`, `start_time`, and `duration` sit at the same
//// position in every variant, so `entry.name` / `entry.start_time` /
//// `entry.duration` work without pattern matching.
////
//// Kinds gossamer hasn't bound to their own variant collapse into
//// [`OtherEntry`](#OtherEntry); read `kind` to discriminate and `raw`
//// to decode kind-specific fields via `gleam/dynamic/decode`.

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gleam/time/duration.{type Duration}

/// The kind of entry on the performance timeline. Names match the W3C
/// Performance Timeline registry; `OtherKind(value)` carries any
/// runtime-emitted kind gossamer doesn't recognize. Runtimes only emit
/// a subset — see `performance_observer.supported_entry_types`.
///
pub type Kind {
  /// User-recorded mark (`performance.mark`).
  MarkKind

  /// User-recorded measurement (`performance.measure`).
  MeasureKind

  /// Resource-loading timing (fetch on Node, Deno, Bun; browsers also
  /// emit for `<img>`, `<script>`, etc.).
  ResourceKind

  /// Document navigation timing (browsers).
  NavigationKind

  /// Paint timing — `"first-paint"` and `"first-contentful-paint"`
  /// (browsers).
  PaintKind

  /// Long-task entries — tasks blocking the main thread for more than
  /// 50ms (browsers).
  LongTaskKind

  /// Event-timing entries — input event latency (browsers).
  EventKind

  /// First-input delay entries; superseded by `EventKind` (browsers).
  FirstInputKind

  /// Largest Contentful Paint — the biggest visible element painted
  /// (browsers, Core Web Vital).
  LargestContentfulPaintKind

  /// Cumulative Layout Shift — unexpected visual shifts (browsers,
  /// Core Web Vital).
  LayoutShiftKind

  /// Long-task attribution to scripts (browsers).
  TaskAttributionKind

  /// Page visibility state changes (browsers).
  VisibilityStateKind

  /// Instrumented element rendering timing (browsers).
  ElementKind

  /// Back-forward cache restoration timing (browsers).
  BackForwardCacheRestorationKind

  /// DNS-lookup timing (Node).
  DnsKind

  /// Function-call timing from `performance.timerify` (Node).
  FunctionKind

  /// Garbage-collection timing (Node).
  GcKind

  /// HTTP-request timing for Node's legacy `http` module (Node).
  HttpKind

  /// HTTP/2 stream timing (Node).
  Http2Kind

  /// Network-socket connect timing (Node).
  NetKind

  /// Any other entry-type string the runtime exposes that this
  /// binding doesn't recognize.
  OtherKind(String)
}

/// An entry on the performance timeline. Each variant carries the
/// fields gossamer has bound for its kind; kinds without their own
/// variant fall into [`OtherEntry`](#OtherEntry).
///
pub type PerformanceEntry {
  /// A user-recorded mark — see
  /// [`gossamer/performance/mark`](./performance/mark.html).
  MarkEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    detail: Option(Dynamic),
  )

  /// A user-recorded measurement — see
  /// [`gossamer/performance/measure`](./performance/measure.html).
  MeasureEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    detail: Option(Dynamic),
  )

  /// An entry of a kind gossamer hasn't bound to its own variant.
  /// `kind` is the resolved [`Kind`](#Kind) tag (`OtherKind(name)`
  /// when the runtime emits a kind gossamer doesn't recognize at all);
  /// `raw` is the original JavaScript entry object for manual decoding
  /// via `gleam/dynamic/decode`.
  OtherEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    kind: Kind,
    raw: Dynamic,
  )
}

/// Returns the [`Kind`](#Kind) tag of an entry. Useful for filtering
/// without pattern matching on the full variant.
///
pub fn kind(entry: PerformanceEntry) -> Kind {
  case entry {
    MarkEntry(..) -> MarkKind
    MeasureEntry(..) -> MeasureKind
    OtherEntry(kind:, ..) -> kind
  }
}

@internal
pub fn kind_from_name(name: String) -> Kind {
  case name {
    "mark" -> MarkKind
    "measure" -> MeasureKind
    "resource" -> ResourceKind
    "navigation" -> NavigationKind
    "paint" -> PaintKind
    "longtask" -> LongTaskKind
    "event" -> EventKind
    "first-input" -> FirstInputKind
    "largest-contentful-paint" -> LargestContentfulPaintKind
    "layout-shift" -> LayoutShiftKind
    "taskattribution" -> TaskAttributionKind
    "visibility-state" -> VisibilityStateKind
    "element" -> ElementKind
    "back-forward-cache-restoration" -> BackForwardCacheRestorationKind
    "dns" -> DnsKind
    "function" -> FunctionKind
    "gc" -> GcKind
    "http" -> HttpKind
    "http2" -> Http2Kind
    "net" -> NetKind
    other -> OtherKind(other)
  }
}

@internal
pub fn kind_to_name(kind: Kind) -> String {
  case kind {
    MarkKind -> "mark"
    MeasureKind -> "measure"
    ResourceKind -> "resource"
    NavigationKind -> "navigation"
    PaintKind -> "paint"
    LongTaskKind -> "longtask"
    EventKind -> "event"
    FirstInputKind -> "first-input"
    LargestContentfulPaintKind -> "largest-contentful-paint"
    LayoutShiftKind -> "layout-shift"
    TaskAttributionKind -> "taskattribution"
    VisibilityStateKind -> "visibility-state"
    ElementKind -> "element"
    BackForwardCacheRestorationKind -> "back-forward-cache-restoration"
    DnsKind -> "dns"
    FunctionKind -> "function"
    GcKind -> "gc"
    HttpKind -> "http"
    Http2Kind -> "http2"
    NetKind -> "net"
    OtherKind(name) -> name
  }
}
