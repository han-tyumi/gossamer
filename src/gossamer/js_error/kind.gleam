/// The classification of a `JsError` — one of the standard ECMAScript
/// error types, a `DOMException` (with its `name`), or any other error
/// (with its `name`).
///
pub type JsErrorKind {
  TypeError
  RangeError
  ReferenceError
  SyntaxError
  UriError
  EvalError
  AggregateError
  DomException(name: String)
  Other(name: String)
}
