@external(javascript, "./byte_length_queuing_strategy.type.ts", "ByteLengthQueuingStrategy$")
pub type ByteLengthQueuingStrategy

@external(javascript, "./byte_length_queuing_strategy.ffi.mjs", "new_")
pub fn new(high_water_mark: Int) -> ByteLengthQueuingStrategy

@external(javascript, "./byte_length_queuing_strategy.ffi.mjs", "high_water_mark")
pub fn high_water_mark(strategy: ByteLengthQueuingStrategy) -> Int
