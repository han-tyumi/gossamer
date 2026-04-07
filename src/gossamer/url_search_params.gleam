@external(javascript, "./url_search_params.type.ts", "URLSearchParams$")
pub type URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "new_")
pub fn new() -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "from_string")
pub fn from_string(query: String) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "from_pairs")
pub fn from_pairs(pairs: List(#(String, String))) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "append")
pub fn append(
  params: URLSearchParams,
  name: String,
  value: String,
) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "delete_")
pub fn delete(params: URLSearchParams, name: String) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "delete_value")
pub fn delete_value(
  params: URLSearchParams,
  name: String,
  value: String,
) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "get")
pub fn get(params: URLSearchParams, name: String) -> Result(String, Nil)

@external(javascript, "./url_search_params.ffi.mjs", "get_all")
pub fn get_all(params: URLSearchParams, name: String) -> List(String)

@external(javascript, "./url_search_params.ffi.mjs", "has")
pub fn has(params: URLSearchParams, name: String) -> Bool

@external(javascript, "./url_search_params.ffi.mjs", "has_value")
pub fn has_value(params: URLSearchParams, name: String, value: String) -> Bool

@external(javascript, "./url_search_params.ffi.mjs", "set")
pub fn set(
  params: URLSearchParams,
  name: String,
  value: String,
) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "sort")
pub fn sort(params: URLSearchParams) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "for_each")
pub fn for_each(
  params: URLSearchParams,
  callback: fn(String, String) -> Nil,
) -> Nil

@external(javascript, "./url_search_params.ffi.mjs", "keys")
pub fn keys(params: URLSearchParams) -> List(String)

@external(javascript, "./url_search_params.ffi.mjs", "values")
pub fn values(params: URLSearchParams) -> List(String)

@external(javascript, "./url_search_params.ffi.mjs", "entries")
pub fn entries(params: URLSearchParams) -> List(#(String, String))

@external(javascript, "./url_search_params.ffi.mjs", "to_string")
pub fn to_string(params: URLSearchParams) -> String

@external(javascript, "./url_search_params.ffi.mjs", "size")
pub fn size(params: URLSearchParams) -> Int
