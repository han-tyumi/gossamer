import gossamer/iterator.{type Iterator}

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
  to params: URLSearchParams,
  name name: String,
  value value: String,
) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "delete_")
pub fn delete(
  from params: URLSearchParams,
  name name: String,
) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "delete_value")
pub fn delete_value(
  from params: URLSearchParams,
  name name: String,
  value value: String,
) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "get")
pub fn get(
  from params: URLSearchParams,
  name name: String,
) -> Result(String, Nil)

@external(javascript, "./url_search_params.ffi.mjs", "get_all")
pub fn get_all(from params: URLSearchParams, name name: String) -> List(String)

@external(javascript, "./url_search_params.ffi.mjs", "has")
pub fn has(in params: URLSearchParams, name name: String) -> Bool

@external(javascript, "./url_search_params.ffi.mjs", "has_value")
pub fn has_value(
  in params: URLSearchParams,
  name name: String,
  value value: String,
) -> Bool

@external(javascript, "./url_search_params.ffi.mjs", "set")
pub fn set(
  in params: URLSearchParams,
  name name: String,
  value value: String,
) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "sort")
pub fn sort(params: URLSearchParams) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "for_each")
pub fn for_each(
  in params: URLSearchParams,
  run callback: fn(String, String) -> a,
) -> Nil

@external(javascript, "./url_search_params.ffi.mjs", "keys")
pub fn keys(of params: URLSearchParams) -> Iterator(String, Nil, Nil)

@external(javascript, "./url_search_params.ffi.mjs", "values")
pub fn values(of params: URLSearchParams) -> Iterator(String, Nil, Nil)

@external(javascript, "./url_search_params.ffi.mjs", "entries")
pub fn entries(
  of params: URLSearchParams,
) -> Iterator(#(String, String), Nil, Nil)

@external(javascript, "./url_search_params.ffi.mjs", "to_string")
pub fn to_string(params: URLSearchParams) -> String

@external(javascript, "./url_search_params.ffi.mjs", "size")
pub fn size(of params: URLSearchParams) -> Int
