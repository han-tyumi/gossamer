@external(javascript, "./headers.type.ts", "Headers$")
pub type Headers

@external(javascript, "./headers.ffi.mjs", "new_")
pub fn new() -> Headers

@external(javascript, "./headers.ffi.mjs", "from_pairs")
pub fn from_pairs(pairs: List(#(String, String))) -> Headers

@external(javascript, "./headers.ffi.mjs", "append")
pub fn append(headers: Headers, name: String, value: String) -> Headers

@external(javascript, "./headers.ffi.mjs", "delete_")
pub fn delete(headers: Headers, name: String) -> Headers

@external(javascript, "./headers.ffi.mjs", "get")
pub fn get(headers: Headers, name: String) -> Result(String, Nil)

@external(javascript, "./headers.ffi.mjs", "has")
pub fn has(headers: Headers, name: String) -> Bool

@external(javascript, "./headers.ffi.mjs", "set")
pub fn set(headers: Headers, name: String, value: String) -> Headers

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
