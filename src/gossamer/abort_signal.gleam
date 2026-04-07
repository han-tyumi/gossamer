import gleam/dynamic.{type Dynamic}

@external(javascript, "./abort_signal.type.ts", "AbortSignal$")
pub type AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "abort")
pub fn abort(reason: r) -> AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "any")
pub fn any(signals: List(AbortSignal)) -> AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "timeout")
pub fn timeout(milliseconds: Int) -> AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "is_aborted")
pub fn is_aborted(signal: AbortSignal) -> Bool

@external(javascript, "./abort_signal.ffi.mjs", "reason")
pub fn reason(signal: AbortSignal) -> Dynamic

@external(javascript, "./abort_signal.ffi.mjs", "throw_if_aborted")
pub fn throw_if_aborted(signal: AbortSignal) -> Result(Nil, String)
