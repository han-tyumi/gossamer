import gleam/dynamic.{type Dynamic}

/// Opaque handle to the underlying JS `PerformanceEntry`.
///
@external(javascript, "./performance_entry_ref.type.ts", "PerformanceEntryRef$")
@internal
pub type PerformanceEntryRef

/// A single performance metric produced by the Performance API.
///
/// See [PerformanceEntry](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry) on MDN.
///
pub type PerformanceEntry {
  PerformanceEntry(
    name: String,
    entry_type: String,
    start_time: Float,
    duration: Float,
    /// Internal handle to the underlying JS `PerformanceEntry`. Do not
    /// construct manually.
    ref: PerformanceEntryRef,
  )
}

/// Extra data associated with the entry, or `Error(Nil)` if none was
/// provided.
///
@external(javascript, "./performance_entry.ffi.mjs", "detail")
pub fn detail(of entry: PerformanceEntry) -> Result(Dynamic, Nil)

@external(javascript, "./performance_entry.ffi.mjs", "to_json")
pub fn to_json(entry: PerformanceEntry) -> Dynamic
