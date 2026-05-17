//// Asynchronously receive performance entries as the runtime records
//// them.

import gossamer/performance_entry.{type EntryType, type PerformanceEntry}

/// A subscription that delivers performance entries to a handler.
///
/// See [PerformanceObserver](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver) on MDN.
///
@external(javascript, "./performance_observer.type.ts", "PerformanceObserver$")
pub type PerformanceObserver

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
