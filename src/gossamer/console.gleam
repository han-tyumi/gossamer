//// Access to the runtime's debugging console — log, warn, error, groups,
//// counters, timers, and assertions.
////
//// See [console](https://developer.mozilla.org/en-US/docs/Web/API/console) on MDN.

/// Logs `data` as an error if `condition` is `False`. A no-op when the
/// condition holds. Equivalent to JavaScript's `console.assert`.
///
@external(javascript, "./console.ffi.mjs", "log_if_false")
pub fn log_if_false(that condition: Bool, log data: a) -> Nil

/// Clears the console if the runtime allows it.
///
@external(javascript, "./console.ffi.mjs", "clear")
pub fn clear() -> Nil

/// Logs the number of times [`count`](#count) has been called with
/// `label`. Pair with [`count_reset`](#count_reset) to reset the
/// counter.
///
@external(javascript, "./console.ffi.mjs", "count")
pub fn count(label: String) -> Nil

/// Resets the counter associated with `label`.
///
@external(javascript, "./console.ffi.mjs", "count_reset")
pub fn count_reset(label: String) -> Nil

/// Outputs `data` to the console at the `debug` log level.
///
@external(javascript, "./console.ffi.mjs", "debug")
pub fn debug(data: a) -> Nil

/// Displays an interactive listing of the properties of `item`. Most
/// useful when the runtime renders an inspectable tree (browsers,
/// Node REPL).
///
@external(javascript, "./console.ffi.mjs", "dir")
pub fn dir(item: a) -> Nil

/// Outputs `data` to the console at the `error` log level.
///
@external(javascript, "./console.ffi.mjs", "error")
pub fn error(data: a) -> Nil

/// Starts a new inline group titled `label`. Subsequent console output
/// is indented under the group until [`group_end`](#group_end) is
/// called.
///
@external(javascript, "./console.ffi.mjs", "group")
pub fn group(label: String) -> Nil

/// Like [`group`](#group), but the group is collapsed by default.
///
@external(javascript, "./console.ffi.mjs", "group_collapsed")
pub fn group_collapsed(label: String) -> Nil

/// Exits the current inline group started by [`group`](#group) or
/// [`group_collapsed`](#group_collapsed).
///
@external(javascript, "./console.ffi.mjs", "group_end")
pub fn group_end() -> Nil

/// Outputs `data` to the console at the `info` log level.
///
@external(javascript, "./console.ffi.mjs", "info")
pub fn info(data: a) -> Nil

/// Outputs `data` to the console at the `log` log level — the
/// general-purpose logging entry point.
///
@external(javascript, "./console.ffi.mjs", "log")
pub fn log(data: a) -> Nil

/// Displays `data` as a table. The runtime renders the structure as
/// rows and columns when it can; otherwise falls back to a regular
/// log.
///
@external(javascript, "./console.ffi.mjs", "table")
pub fn table(data: a) -> Nil

/// Starts a timer identified by `label`. Pair with
/// [`time_log`](#time_log) to read the elapsed time and
/// [`time_end`](#time_end) to stop the timer.
///
@external(javascript, "./console.ffi.mjs", "time")
pub fn time(label: String) -> Nil

/// Stops the timer identified by `label` and logs the elapsed time.
///
@external(javascript, "./console.ffi.mjs", "time_end")
pub fn time_end(label: String) -> Nil

/// Logs the current elapsed time for the timer identified by `label`
/// without stopping it.
///
@external(javascript, "./console.ffi.mjs", "time_log")
pub fn time_log(label: String) -> Nil

/// Outputs a stack trace to the console at the point of call.
///
@external(javascript, "./console.ffi.mjs", "trace")
pub fn trace() -> Nil

/// Outputs `data` to the console at the `warn` log level.
///
@external(javascript, "./console.ffi.mjs", "warn")
pub fn warn(data: a) -> Nil
