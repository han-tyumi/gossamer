@external(javascript, "./abort_signal.ffi.ts", "AbortSignal$")
pub type AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "abort")
pub fn abort(reason: r) -> AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "any")
pub fn any(signals: List(AbortSignal)) -> AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "timeout")
pub fn timeout(milliseconds: Int) -> AbortSignal
