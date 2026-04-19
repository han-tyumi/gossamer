import gossamer/iterator.{type Iterator}

/// An HTTP header set used with `fetch`, `Request`, and `Response`. Headers
/// are mutable — methods like `append`, `delete`, and `set` modify the set
/// in place.
///
/// See [Headers](https://developer.mozilla.org/en-US/docs/Web/API/Headers) on MDN.
///
@external(javascript, "./headers.type.ts", "Headers$")
pub type Headers

@external(javascript, "./headers.ffi.mjs", "new_")
pub fn new() -> Headers

/// Creates a `Headers` object from a list of name/value pairs. Returns an
/// error if any name or value is not a valid ByteString.
///
@external(javascript, "./headers.ffi.mjs", "from_pairs")
pub fn from_pairs(pairs: List(#(String, String))) -> Result(Headers, String)

/// Appends a new value onto an existing header, or adds the header if it does
/// not already exist. Mutates the headers in-place and returns them for
/// chaining. Returns an error if the name or value is not a valid ByteString.
///
@external(javascript, "./headers.ffi.mjs", "append")
pub fn append(
  to headers: Headers,
  name name: String,
  value value: String,
) -> Result(Headers, String)

/// Deletes a header. Mutates the headers in-place and returns them for
/// chaining. Returns an error if the name is not a valid ByteString.
///
@external(javascript, "./headers.ffi.mjs", "delete_")
pub fn delete(
  from headers: Headers,
  name name: String,
) -> Result(Headers, String)

/// Returns the value for `name`, combining multiple values with `, `.
/// Returns an error if `name` is not a valid ByteString or no such header
/// exists.
///
@external(javascript, "./headers.ffi.mjs", "get")
pub fn get(from headers: Headers, name name: String) -> Result(String, String)

/// Checks whether a header with `name` exists. Returns an error if `name`
/// is not a valid ByteString.
///
@external(javascript, "./headers.ffi.mjs", "has")
pub fn has(in headers: Headers, name name: String) -> Result(Bool, String)

/// Sets a new value for an existing header, or adds the header if it does not
/// already exist. Mutates the headers in-place and returns them for chaining.
/// Returns an error if the name or value is not a valid ByteString.
///
@external(javascript, "./headers.ffi.mjs", "set")
pub fn set(
  in headers: Headers,
  name name: String,
  value value: String,
) -> Result(Headers, String)

/// Returns the values of all `Set-Cookie` headers separately (rather than
/// combining them with `, ` like `get` would).
///
@external(javascript, "./headers.ffi.mjs", "get_set_cookie")
pub fn get_set_cookie(from headers: Headers) -> List(String)

@external(javascript, "./headers.ffi.mjs", "keys")
pub fn keys(of headers: Headers) -> Iterator(String, Nil, Nil)

@external(javascript, "./headers.ffi.mjs", "values")
pub fn values(of headers: Headers) -> Iterator(String, Nil, Nil)

@external(javascript, "./headers.ffi.mjs", "entries")
pub fn entries(of headers: Headers) -> Iterator(#(String, String), Nil, Nil)

@external(javascript, "./headers.ffi.mjs", "for_each")
pub fn for_each(
  in headers: Headers,
  run callback: fn(String, String) -> a,
) -> Nil
