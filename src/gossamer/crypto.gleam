import gossamer/uint8_array.{type Uint8Array}

@external(javascript, "./crypto.ffi.mjs", "get_random_values")
pub fn get_random_values(array: Uint8Array) -> Uint8Array

@external(javascript, "./crypto.ffi.mjs", "random_uuid")
pub fn random_uuid() -> String
