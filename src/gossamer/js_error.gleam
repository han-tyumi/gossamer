import gleam/dynamic.{type Dynamic}
import gossamer/js_error/kind.{type JsErrorKind}

/// A standard JS `Error` object with a name, message, and optional stack
/// trace. Useful when constructing errors to pass to JS APIs and for
/// inspecting errors caught from JS calls.
///
/// See [Error](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) on MDN.
///
@external(javascript, "./js_error.type.ts", "JsError$")
pub type JsError

@external(javascript, "./js_error.ffi.mjs", "new_")
pub fn new(message: String) -> JsError

/// Creates a `JsError` with `message` and an attached `cause` (ES2022).
/// The cause is retrievable via `cause(error)`.
///
@external(javascript, "./js_error.ffi.mjs", "new_with_cause")
pub fn new_with_cause(message: String, cause cause: a) -> JsError

@external(javascript, "./js_error.ffi.mjs", "type_error")
pub fn type_error(message: String) -> JsError

/// Creates a `TypeError` with `message` and an attached `cause`.
///
@external(javascript, "./js_error.ffi.mjs", "type_error_with_cause")
pub fn type_error_with_cause(message: String, cause cause: a) -> JsError

@external(javascript, "./js_error.ffi.mjs", "range_error")
pub fn range_error(message: String) -> JsError

/// Creates a `RangeError` with `message` and an attached `cause`.
///
@external(javascript, "./js_error.ffi.mjs", "range_error_with_cause")
pub fn range_error_with_cause(message: String, cause cause: a) -> JsError

@external(javascript, "./js_error.ffi.mjs", "reference_error")
pub fn reference_error(message: String) -> JsError

/// Creates a `ReferenceError` with `message` and an attached `cause`.
///
@external(javascript, "./js_error.ffi.mjs", "reference_error_with_cause")
pub fn reference_error_with_cause(message: String, cause cause: a) -> JsError

@external(javascript, "./js_error.ffi.mjs", "syntax_error")
pub fn syntax_error(message: String) -> JsError

/// Creates a `SyntaxError` with `message` and an attached `cause`.
///
@external(javascript, "./js_error.ffi.mjs", "syntax_error_with_cause")
pub fn syntax_error_with_cause(message: String, cause cause: a) -> JsError

@external(javascript, "./js_error.ffi.mjs", "uri_error")
pub fn uri_error(message: String) -> JsError

/// Creates a `URIError` with `message` and an attached `cause`.
///
@external(javascript, "./js_error.ffi.mjs", "uri_error_with_cause")
pub fn uri_error_with_cause(message: String, cause cause: a) -> JsError

@external(javascript, "./js_error.ffi.mjs", "eval_error")
pub fn eval_error(message: String) -> JsError

/// Creates an `EvalError` with `message` and an attached `cause`.
///
@external(javascript, "./js_error.ffi.mjs", "eval_error_with_cause")
pub fn eval_error_with_cause(message: String, cause cause: a) -> JsError

@external(javascript, "./js_error.ffi.mjs", "name")
pub fn name(of error: JsError) -> String

@external(javascript, "./js_error.ffi.mjs", "message")
pub fn message(of error: JsError) -> String

/// The stack trace captured when the error was created, or `Error(Nil)` if
/// the runtime didn't attach one.
///
@external(javascript, "./js_error.ffi.mjs", "stack")
pub fn stack(of error: JsError) -> Result(String, Nil)

/// The cause attached to the error, or `Error(Nil)` if no cause was set.
///
@external(javascript, "./js_error.ffi.mjs", "cause")
pub fn cause(of error: JsError) -> Result(Dynamic, Nil)

/// The classification of `error` — one of the standard ECMAScript error
/// kinds, `DomException(name:)` for a `DOMException` with its `name`, or
/// `Other(name:)` for any other error (including plain `Error` and custom
/// error subclasses).
///
@external(javascript, "./js_error.ffi.mjs", "kind")
pub fn kind(of error: JsError) -> JsErrorKind
