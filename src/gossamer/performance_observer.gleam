//// Asynchronously receive performance entries as the runtime records
//// them. Subscribe to many kinds at once via [`observe`](#observe), or
//// to a single kind with buffer replay via
//// [`observe_buffered`](#observe_buffered). The handler receives a
//// [`Batch`](#Batch) of new entries plus the
//// [`PerformanceObserver`](#PerformanceObserver) itself for
//// in-handler [`disconnect`](#disconnect) /
//// [`take_records`](#take_records) calls.

import gossamer/performance_entry.{type Kind, type PerformanceEntry}

/// A subscription that delivers performance entries to a handler.
///
/// See [PerformanceObserver](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver) on MDN.
///
@external(javascript, "./performance_observer.type.ts", "PerformanceObserver$")
pub type PerformanceObserver

/// The entries delivered to a handler on a single observer
/// invocation, plus the count of entries the runtime dropped from
/// its global buffer before this observer started observing.
///
pub type Batch {
  Batch(
    /// The entries delivered to the handler on this invocation.
    entries: List(PerformanceEntry),
    /// The count of entries the runtime dropped from its global
    /// buffer due to overflow. Reported only on the first invocation
    /// of an [`observe_buffered`](#observe_buffered) observer; always
    /// zero on other observers and on subsequent invocations.
    dropped: Int,
  )
}

/// Subscribes to performance entries of the given kinds. The handler
/// receives a [`Batch`](#Batch) of new entries plus the
/// [`PerformanceObserver`](#PerformanceObserver) so it can call
/// [`disconnect`](#disconnect) or [`take_records`](#take_records)
/// from inside (e.g., auto-disconnect after the first batch).
/// Equivalent to constructing a JavaScript `PerformanceObserver` and
/// calling `observer.observe({ entryTypes: [...] })`.
///
/// Kind support differs across runtimes — see
/// [`supported_entry_types`](#supported_entry_types).
///
@external(javascript, "./performance_observer.ffi.mjs", "observe")
pub fn observe(
  for entry_kinds: List(Kind),
  run handler: fn(Batch, PerformanceObserver) -> a,
) -> PerformanceObserver

/// Subscribes to a single entry kind and replays any entries the
/// runtime has already buffered for that kind. Useful when the
/// observer attaches after some entries were recorded. The handler
/// also receives the [`PerformanceObserver`](#PerformanceObserver).
/// Equivalent to constructing a JavaScript `PerformanceObserver` and
/// calling `observer.observe({ type: ..., buffered: true })`.
///
@external(javascript, "./performance_observer.ffi.mjs", "observe_buffered")
pub fn observe_buffered(
  for entry_kind: Kind,
  run handler: fn(Batch, PerformanceObserver) -> a,
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

/// Returns the entry kinds this runtime's `PerformanceObserver`
/// accepts. Every runtime accepts
/// [`MarkKind`](./performance_entry.html#Kind) and
/// [`MeasureKind`](./performance_entry.html#Kind); Node accepts a
/// larger set including resource-loading and several runtime-
/// internal kinds (DNS, GC, etc.) that arrive wrapped as
/// `OtherKind(name)`.
///
@external(javascript, "./performance_observer.ffi.mjs", "supported_entry_types")
pub fn supported_entry_types() -> List(Kind)
