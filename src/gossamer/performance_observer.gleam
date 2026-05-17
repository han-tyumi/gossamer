//// Asynchronously receive performance entries as the runtime records
//// them.

import gossamer/performance_entry.{type PerformanceEntry}

/// A subscription that delivers performance entries to a handler.
///
/// See [PerformanceObserver](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver) on MDN.
///
@external(javascript, "./performance_observer.type.ts", "PerformanceObserver$")
pub type PerformanceObserver

/// The category of entry a [`PerformanceObserver`](#PerformanceObserver)
/// subscribes to. Maps the JavaScript `entryTypes` / `type` strings;
/// runtimes only accept a subset (see
/// [`supported_entry_types`](#supported_entry_types)).
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

/// Subscribes to performance entries of the given types. The handler
/// is called with new entries as they're recorded. Call
/// [`disconnect`](#disconnect) on the returned observer to stop.
///
/// Entry-type support differs across runtimes — see
/// [`supported_entry_types`](#supported_entry_types).
///
@external(javascript, "./performance_observer.ffi.mjs", "observe")
pub fn observe(
  for entry_types: List(EntryType),
  run handler: fn(List(PerformanceEntry)) -> a,
) -> PerformanceObserver

/// Subscribes to a single entry type and replays any entries the
/// runtime has already buffered for that type. Useful when the
/// observer attaches after some entries were recorded. Call
/// [`disconnect`](#disconnect) to stop.
///
@external(javascript, "./performance_observer.ffi.mjs", "observe_buffered")
pub fn observe_buffered(
  for entry_type: EntryType,
  run handler: fn(List(PerformanceEntry)) -> a,
) -> PerformanceObserver

/// Stops the observer from receiving further entries. Any pending
/// entries are discarded — call [`take_records`](#take_records) first
/// to drain them.
///
@external(javascript, "./performance_observer.ffi.mjs", "disconnect")
pub fn disconnect(observer: PerformanceObserver) -> Nil

/// Returns and clears any entries that have been recorded but not yet
/// delivered to the handler.
///
@external(javascript, "./performance_observer.ffi.mjs", "take_records")
pub fn take_records(observer: PerformanceObserver) -> List(PerformanceEntry)

/// Returns the entry types supported by this runtime's
/// `PerformanceObserver`. Deno supports `Mark` and `Measure`; Node
/// and Bun support a larger set that includes `Resource`.
///
@external(javascript, "./performance_observer.ffi.mjs", "supported_entry_types")
pub fn supported_entry_types() -> List(EntryType)
