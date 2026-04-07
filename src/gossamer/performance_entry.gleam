import gleam/dynamic.{type Dynamic}

@external(javascript, "./performance_entry.type.ts", "PerformanceEntry$")
pub type PerformanceEntry

@external(javascript, "./performance_entry.ffi.mjs", "name")
pub fn name(entry: PerformanceEntry) -> String

@external(javascript, "./performance_entry.ffi.mjs", "entry_type")
pub fn entry_type(entry: PerformanceEntry) -> String

@external(javascript, "./performance_entry.ffi.mjs", "start_time")
pub fn start_time(entry: PerformanceEntry) -> Float

@external(javascript, "./performance_entry.ffi.mjs", "duration")
pub fn duration(entry: PerformanceEntry) -> Float

@external(javascript, "./performance_entry.ffi.mjs", "detail")
pub fn detail(entry: PerformanceEntry) -> Result(Dynamic, Nil)

@external(javascript, "./performance_entry.ffi.mjs", "to_json")
pub fn to_json(entry: PerformanceEntry) -> Dynamic
