@external(javascript, "./headers.type.ts", "Headers$")
pub type Headers

@external(javascript, "./headers.ffi.mjs", "new_")
pub fn new() -> Headers

@external(javascript, "./headers.ffi.mjs", "from_pairs")
pub fn from_pairs(pairs: List(#(String, String))) -> Headers

/// Appends a new value onto an existing header, or adds the header if it does
/// not already exist. Mutates the headers in-place and returns them for
/// chaining.
///
@external(javascript, "./headers.ffi.mjs", "append")
pub fn append(
  to headers: Headers,
  name name: String,
  value value: String,
) -> Headers

/// Deletes a header. Mutates the headers in-place and returns them for
/// chaining.
///
@external(javascript, "./headers.ffi.mjs", "delete_")
pub fn delete(from headers: Headers, name name: String) -> Headers

@external(javascript, "./headers.ffi.mjs", "get")
pub fn get(from headers: Headers, name name: String) -> Result(String, Nil)

@external(javascript, "./headers.ffi.mjs", "has")
pub fn has(in headers: Headers, name name: String) -> Bool

/// Sets a new value for an existing header, or adds the header if it does not
/// already exist. Mutates the headers in-place and returns them for chaining.
///
@external(javascript, "./headers.ffi.mjs", "set")
pub fn set(
  in headers: Headers,
  name name: String,
  value value: String,
) -> Headers

@external(javascript, "./headers.ffi.mjs", "get_set_cookie")
pub fn get_set_cookie(from headers: Headers) -> List(String)

@external(javascript, "./headers.ffi.mjs", "keys")
pub fn keys(of headers: Headers) -> List(String)

@external(javascript, "./headers.ffi.mjs", "values")
pub fn values(of headers: Headers) -> List(String)

@external(javascript, "./headers.ffi.mjs", "entries")
pub fn entries(of headers: Headers) -> List(#(String, String))

@external(javascript, "./headers.ffi.mjs", "for_each")
pub fn for_each(
  in headers: Headers,
  run callback: fn(String, String) -> Nil,
) -> Nil
