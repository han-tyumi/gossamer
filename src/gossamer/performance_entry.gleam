//// A single entry on the performance timeline — a mark, a measure, or
//// another runtime-recorded metric. Returned by
//// [`performance.entries`](./performance.html#entries) and the
//// `entries_*` queries, and delivered to
//// [`performance_observer`](./performance_observer.html) callbacks.
////
//// Every entry carries the four base fields the W3C
//// [PerformanceEntry interface](https://w3c.github.io/performance-timeline/#dom-performanceentry)
//// defines (`name`, `entryType`, `startTime`, `duration`). The
//// `entryType` string surfaces as a typed [`Kind`](#Kind); the
//// original JavaScript entry stays accessible via `raw` for kind-
//// specific decoding through `gleam/dynamic/decode`.
////
//// Project to a typed
//// [`Mark`](./performance/mark.html#Mark) or
//// [`Measure`](./performance/measure.html#Measure) via the
//// submodules' `from_entry` helpers.

import gleam/dynamic.{type Dynamic}
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

  /// Any other entry-type string the runtime exposes that this
  /// binding doesn't recognize.
  OtherKind(String)
}

/// An entry on the performance timeline. Carries the W3C base fields
/// plus a typed [`Kind`](#Kind) discriminator and a `raw` reference
/// to the original JavaScript entry for kind-specific decoding.
///
pub type PerformanceEntry {
  PerformanceEntry(
    /// The entry's name. For marks and measures, the name the user
    /// recorded; for other kinds, an entry-type-specific label.
    name: String,
    /// When the entry began, relative to
    /// [`performance.time_origin`](./performance.html#time_origin).
    start_time: Duration,
    /// The entry's span length. Zero for marks and other point-in-
    /// time kinds.
    duration: Duration,
    /// The kind of entry — [`MarkKind`](#Kind) /
    /// [`MeasureKind`](#Kind) / [`OtherKind`](#Kind) for everything
    /// else.
    kind: Kind,
    /// The original JavaScript entry, for manual decoding via
    /// `gleam/dynamic/decode`.
    raw: Dynamic,
  )
}

@internal
pub fn kind_from_name(name: String) -> Kind {
  case name {
    "mark" -> MarkKind
    "measure" -> MeasureKind
    other -> OtherKind(other)
  }
}

@internal
pub fn kind_to_name(kind: Kind) -> String {
  case kind {
    MarkKind -> "mark"
    MeasureKind -> "measure"
    OtherKind(name) -> name
  }
}
