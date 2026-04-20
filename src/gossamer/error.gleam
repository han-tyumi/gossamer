import gleam/dynamic.{type Dynamic}

/// A standard JS `Error` object with a name, message, and optional stack
/// trace. Useful when constructing errors to pass to JS APIs.
///
/// See [Error](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) on MDN.
///
@external(javascript, "./error.type.ts", "Error$")
pub type Error

@external(javascript, "./error.ffi.mjs", "new_")
pub fn new(message: String) -> Error

@external(javascript, "./error.ffi.mjs", "type_error")
pub fn type_error(message: String) -> Error

@external(javascript, "./error.ffi.mjs", "range_error")
pub fn range_error(message: String) -> Error

@external(javascript, "./error.ffi.mjs", "reference_error")
pub fn reference_error(message: String) -> Error

@external(javascript, "./error.ffi.mjs", "syntax_error")
pub fn syntax_error(message: String) -> Error

@external(javascript, "./error.ffi.mjs", "uri_error")
pub fn uri_error(message: String) -> Error

@external(javascript, "./error.ffi.mjs", "eval_error")
pub fn eval_error(message: String) -> Error

@external(javascript, "./error.ffi.mjs", "name")
pub fn name(of error: Error) -> String

@external(javascript, "./error.ffi.mjs", "message")
pub fn message(of error: Error) -> String

/// The stack trace captured when the error was created, or `Error(Nil)` if
/// the runtime didn't attach one.
///
@external(javascript, "./error.ffi.mjs", "stack")
pub fn stack(of error: Error) -> Result(String, Nil)

/// The cause attached to the error, or `Error(Nil)` if no cause was set.
///
@external(javascript, "./error.ffi.mjs", "cause")
pub fn cause(of error: Error) -> Result(Dynamic, Nil)
