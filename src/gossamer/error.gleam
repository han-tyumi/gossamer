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

/// Creates an `Error` with `message` and an attached `cause` (ES2022).
/// The cause is retrievable via `cause(error)`.
///
@external(javascript, "./error.ffi.mjs", "new_with_cause")
pub fn new_with_cause(message: String, cause cause: a) -> Error

@external(javascript, "./error.ffi.mjs", "type_error")
pub fn type_error(message: String) -> Error

/// Creates a `TypeError` with `message` and an attached `cause`.
///
@external(javascript, "./error.ffi.mjs", "type_error_with_cause")
pub fn type_error_with_cause(message: String, cause cause: a) -> Error

@external(javascript, "./error.ffi.mjs", "range_error")
pub fn range_error(message: String) -> Error

/// Creates a `RangeError` with `message` and an attached `cause`.
///
@external(javascript, "./error.ffi.mjs", "range_error_with_cause")
pub fn range_error_with_cause(message: String, cause cause: a) -> Error

@external(javascript, "./error.ffi.mjs", "reference_error")
pub fn reference_error(message: String) -> Error

/// Creates a `ReferenceError` with `message` and an attached `cause`.
///
@external(javascript, "./error.ffi.mjs", "reference_error_with_cause")
pub fn reference_error_with_cause(message: String, cause cause: a) -> Error

@external(javascript, "./error.ffi.mjs", "syntax_error")
pub fn syntax_error(message: String) -> Error

/// Creates a `SyntaxError` with `message` and an attached `cause`.
///
@external(javascript, "./error.ffi.mjs", "syntax_error_with_cause")
pub fn syntax_error_with_cause(message: String, cause cause: a) -> Error

@external(javascript, "./error.ffi.mjs", "uri_error")
pub fn uri_error(message: String) -> Error

/// Creates a `URIError` with `message` and an attached `cause`.
///
@external(javascript, "./error.ffi.mjs", "uri_error_with_cause")
pub fn uri_error_with_cause(message: String, cause cause: a) -> Error

@external(javascript, "./error.ffi.mjs", "eval_error")
pub fn eval_error(message: String) -> Error

/// Creates an `EvalError` with `message` and an attached `cause`.
///
@external(javascript, "./error.ffi.mjs", "eval_error_with_cause")
pub fn eval_error_with_cause(message: String, cause cause: a) -> Error

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
