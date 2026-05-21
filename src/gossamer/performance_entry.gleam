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
    /// User-supplied metadata attached at record time.
    detail: Option(Dynamic),
  )

  /// A user-recorded measurement — see
  /// [`gossamer/performance/measure`](./performance/measure.html).
  MeasureEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    /// User-supplied metadata attached at record time.
    detail: Option(Dynamic),
  )

  /// An entry of a kind gossamer hasn't bound to its own variant.
  OtherEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    /// The resolved [`Kind`](#Kind) tag — `OtherKind(name)` when the
    /// runtime emits a kind gossamer doesn't recognize at all.
    kind: Kind,
    /// The original JavaScript entry, for manual decoding via
    /// `gleam/dynamic/decode`.
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
