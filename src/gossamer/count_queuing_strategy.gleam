/// A queuing strategy for streams that counts queued chunks regardless
/// of their size.
///
/// See [CountQueuingStrategy](https://developer.mozilla.org/en-US/docs/Web/API/CountQueuingStrategy) on MDN.
///
@external(javascript, "./count_queuing_strategy.type.ts", "CountQueuingStrategy$")
pub type CountQueuingStrategy

@external(javascript, "./count_queuing_strategy.ffi.mjs", "new_")
pub fn new(high_water_mark: Float) -> CountQueuingStrategy

@external(javascript, "./count_queuing_strategy.ffi.mjs", "high_water_mark")
pub fn high_water_mark(of strategy: CountQueuingStrategy) -> Float
