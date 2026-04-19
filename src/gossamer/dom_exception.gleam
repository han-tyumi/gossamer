/// An exception from the Web Platform, with a name, message, and error
/// code. Used by many Web APIs to signal error conditions.
///
/// See [DOMException](https://developer.mozilla.org/en-US/docs/Web/API/DOMException) on MDN.
///
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
