import gleam/dynamic.{type Dynamic}

/// A single performance metric produced by the Performance API.
///
/// See [PerformanceEntry](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry) on MDN.
///
@external(javascript, "./performance_entry.type.ts", "PerformanceEntry$")
pub type PerformanceEntry

/// The stable properties shared by every `PerformanceEntry`. Subtype-specific
/// properties (`detail`) and the JSON view (`to_json`) stay as separate
/// functions.
///
pub type Fields {
  Fields(name: String, entry_type: String, start_time: Float, duration: Float)
}

@external(javascript, "./performance_entry.ffi.mjs", "to_fields")
pub fn to_fields(entry: PerformanceEntry) -> Fields

@external(javascript, "./performance_entry.ffi.mjs", "name")
pub fn name(of entry: PerformanceEntry) -> String

@external(javascript, "./performance_entry.ffi.mjs", "entry_type")
pub fn entry_type(of entry: PerformanceEntry) -> String

@external(javascript, "./performance_entry.ffi.mjs", "start_time")
pub fn start_time(of entry: PerformanceEntry) -> Float

@external(javascript, "./performance_entry.ffi.mjs", "duration")
pub fn duration(of entry: PerformanceEntry) -> Float

/// Extra data associated with the entry, or `Error(Nil)` if none was
/// provided.
///
@external(javascript, "./performance_entry.ffi.mjs", "detail")
pub fn detail(of entry: PerformanceEntry) -> Result(Dynamic, Nil)

@external(javascript, "./performance_entry.ffi.mjs", "to_json")
pub fn to_json(entry: PerformanceEntry) -> Dynamic
