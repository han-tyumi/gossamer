@external(javascript, "./dom_exception.type.ts", "DOMException$")
pub type DOMException

@external(javascript, "./dom_exception.ffi.mjs", "new_")
pub fn new(message: String, name: String) -> DOMException

@external(javascript, "./dom_exception.ffi.mjs", "message")
pub fn message(exception: DOMException) -> String

@external(javascript, "./dom_exception.ffi.mjs", "name")
pub fn name(exception: DOMException) -> String

@external(javascript, "./dom_exception.ffi.mjs", "code")
pub fn code(exception: DOMException) -> Int
