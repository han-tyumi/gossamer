/// A queuing strategy for streams that counts queued chunks regardless
/// of their size.
///
/// See [CountQueuingStrategy](https://developer.mozilla.org/en-US/docs/Web/API/CountQueuingStrategy) on MDN.
///
@external(javascript, "./count_queuing_strategy.type.ts", "CountQueuingStrategy$")
pub type CountQueuingStrategy

/// The queue size threshold at which a stream signals backpressure.
/// `Unlimited` disables backpressure entirely.
///
pub type HighWaterMark {
  Chunks(Int)
  Unlimited
}

@external(javascript, "./count_queuing_strategy.ffi.mjs", "new_")
pub fn new(high_water_mark: HighWaterMark) -> CountQueuingStrategy

@external(javascript, "./count_queuing_strategy.ffi.mjs", "high_water_mark")
pub fn high_water_mark(of strategy: CountQueuingStrategy) -> HighWaterMark
