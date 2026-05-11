/// A queuing strategy for streams that measures queued chunks by their
/// byte length.
///
/// See [ByteLengthQueuingStrategy](https://developer.mozilla.org/en-US/docs/Web/API/ByteLengthQueuingStrategy) on MDN.
///
@external(javascript, "./byte_length_queuing_strategy.type.ts", "ByteLengthQueuingStrategy$")
pub type ByteLengthQueuingStrategy

/// The queue size threshold at which a stream signals backpressure.
/// `Unlimited` disables backpressure entirely.
///
pub type HighWaterMark {
  Bytes(Int)
  Unlimited
}

@external(javascript, "./byte_length_queuing_strategy.ffi.mjs", "new_")
pub fn new(high_water_mark: HighWaterMark) -> ByteLengthQueuingStrategy

@external(javascript, "./byte_length_queuing_strategy.ffi.mjs", "high_water_mark")
pub fn high_water_mark(of strategy: ByteLengthQueuingStrategy) -> HighWaterMark
