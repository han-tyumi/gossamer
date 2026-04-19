//// Access to the runtime's debugging console — log, warn, error, groups,
//// counters, timers, and assertions.
////
//// See [console](https://developer.mozilla.org/en-US/docs/Web/API/console) on MDN.

@external(javascript, "./console.ffi.mjs", "assert_")
pub fn assert_(that condition: Bool, log data: a) -> Nil

@external(javascript, "./console.ffi.mjs", "clear")
pub fn clear() -> Nil

@external(javascript, "./console.ffi.mjs", "count")
pub fn count(label: String) -> Nil

@external(javascript, "./console.ffi.mjs", "count_reset")
pub fn count_reset(label: String) -> Nil

@external(javascript, "./console.ffi.mjs", "debug")
pub fn debug(data: a) -> Nil

@external(javascript, "./console.ffi.mjs", "dir")
pub fn dir(item: a) -> Nil

@external(javascript, "./console.ffi.mjs", "error")
pub fn error(data: a) -> Nil

@external(javascript, "./console.ffi.mjs", "group")
pub fn group(label: String) -> Nil

@external(javascript, "./console.ffi.mjs", "group_collapsed")
pub fn group_collapsed(label: String) -> Nil

@external(javascript, "./console.ffi.mjs", "group_end")
pub fn group_end() -> Nil

@external(javascript, "./console.ffi.mjs", "info")
pub fn info(data: a) -> Nil

@external(javascript, "./console.ffi.mjs", "log")
pub fn log(data: a) -> Nil

@external(javascript, "./console.ffi.mjs", "table")
pub fn table(data: a) -> Nil

@external(javascript, "./console.ffi.mjs", "time")
pub fn time(label: String) -> Nil

@external(javascript, "./console.ffi.mjs", "time_end")
pub fn time_end(label: String) -> Nil

@external(javascript, "./console.ffi.mjs", "time_log")
pub fn time_log(label: String) -> Nil

@external(javascript, "./console.ffi.mjs", "trace")
pub fn trace() -> Nil

@external(javascript, "./console.ffi.mjs", "warn")
pub fn warn(data: a) -> Nil
