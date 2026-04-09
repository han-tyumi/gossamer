@external(javascript, "./dom_exception.type.ts", "DOMException$")
pub type DOMException

@external(javascript, "./dom_exception.ffi.mjs", "new_")
pub fn new(message message: String, named name: String) -> DOMException

@external(javascript, "./dom_exception.ffi.mjs", "message")
pub fn message(of exception: DOMException) -> String

@external(javascript, "./dom_exception.ffi.mjs", "name")
pub fn name(of exception: DOMException) -> String

@external(javascript, "./dom_exception.ffi.mjs", "code")
pub fn code(of exception: DOMException) -> Int
