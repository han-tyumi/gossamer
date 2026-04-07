/// This Fetch API interface allows you to perform various actions on HTTP
/// request and response headers. These actions include retrieving, setting,
/// adding to, and removing. A Headers object has an associated header list,
/// which is initially empty and consists of zero or more name and value pairs.
///
@external(javascript, "./headers.type.ts", "Headers$")
pub type Headers

@external(javascript, "./headers.ffi.mjs", "new_")
pub fn new() -> Headers

@external(javascript, "./headers.ffi.mjs", "from_pairs")
pub fn from_pairs(pairs: List(#(String, String))) -> Headers

/// Appends a new value onto an existing header inside a `Headers` object, or
/// adds the header if it does not already exist.
///
@external(javascript, "./headers.ffi.mjs", "append")
pub fn append(headers: Headers, name: String, value: String) -> Headers

/// Deletes a header from a `Headers` object.
///
@external(javascript, "./headers.ffi.mjs", "delete_")
pub fn delete(headers: Headers, name: String) -> Headers

/// Returns a `ByteString` sequence of all the values of a header within a
/// `Headers` object with a given name.
///
@external(javascript, "./headers.ffi.mjs", "get")
pub fn get(headers: Headers, name: String) -> Result(String, Nil)

/// Returns a boolean stating whether a `Headers` object contains a certain
/// header.
///
@external(javascript, "./headers.ffi.mjs", "has")
pub fn has(headers: Headers, name: String) -> Bool

/// Sets a new value for an existing header inside a Headers object, or adds
/// the header if it does not already exist.
///
@external(javascript, "./headers.ffi.mjs", "set")
pub fn set(headers: Headers, name: String, value: String) -> Headers

/// Returns an array containing the values of all `Set-Cookie` headers
/// associated with a response.
///
@external(javascript, "./headers.ffi.mjs", "get_set_cookie")
pub fn get_set_cookie(headers: Headers) -> List(String)

@external(javascript, "./headers.ffi.mjs", "keys")
pub fn keys(headers: Headers) -> List(String)

@external(javascript, "./headers.ffi.mjs", "values")
pub fn values(headers: Headers) -> List(String)

@external(javascript, "./headers.ffi.mjs", "entries")
pub fn entries(headers: Headers) -> List(#(String, String))

@external(javascript, "./headers.ffi.mjs", "for_each")
pub fn for_each(headers: Headers, callback: fn(String, String) -> Nil) -> Nil
