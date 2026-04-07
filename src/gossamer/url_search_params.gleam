import gleam/option.{type Option}

/// URLSearchParams provides methods for working with the query string of a URL.
///
@external(javascript, "./url_search_params.type.ts", "URLSearchParams$")
pub type URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "new_")
pub fn new() -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "from_string")
pub fn from_string(query: String) -> URLSearchParams

@external(javascript, "./url_search_params.ffi.mjs", "from_pairs")
pub fn from_pairs(pairs: List(#(String, String))) -> URLSearchParams

/// Appends a specified key/value pair as a new search parameter.
///
@external(javascript, "./url_search_params.ffi.mjs", "append")
pub fn append(
  params: URLSearchParams,
  name: String,
  value: String,
) -> URLSearchParams

/// Deletes search parameters that match a name from the list of all search
/// parameters.
///
@external(javascript, "./url_search_params.ffi.mjs", "delete_")
pub fn delete(params: URLSearchParams, name: String) -> URLSearchParams

/// Deletes search parameters that match a name and value from the list of
/// all search parameters.
///
@external(javascript, "./url_search_params.ffi.mjs", "delete_value")
pub fn delete_value(
  params: URLSearchParams,
  name: String,
  value: String,
) -> URLSearchParams

/// Returns the first value associated to the given search parameter.
///
@external(javascript, "./url_search_params.ffi.mjs", "get")
pub fn get(params: URLSearchParams, name: String) -> Option(String)

/// Returns all the values associated with a given search parameter as a
/// list.
///
@external(javascript, "./url_search_params.ffi.mjs", "get_all")
pub fn get_all(params: URLSearchParams, name: String) -> List(String)

/// Returns a boolean value indicating if a given parameter exists.
///
@external(javascript, "./url_search_params.ffi.mjs", "has")
pub fn has(params: URLSearchParams, name: String) -> Bool

/// Returns a boolean value indicating if a given parameter and value pair
/// exists.
///
@external(javascript, "./url_search_params.ffi.mjs", "has_value")
pub fn has_value(params: URLSearchParams, name: String, value: String) -> Bool

/// Sets the value associated with a given search parameter to the given
/// value. If there were several matching values, this method deletes the
/// others. If the search parameter doesn't exist, this method creates it.
///
@external(javascript, "./url_search_params.ffi.mjs", "set")
pub fn set(
  params: URLSearchParams,
  name: String,
  value: String,
) -> URLSearchParams

/// Sort all key/value pairs contained in this object in place. The sort
/// order is according to Unicode code points of the keys.
///
@external(javascript, "./url_search_params.ffi.mjs", "sort")
pub fn sort(params: URLSearchParams) -> URLSearchParams

/// Calls a function for each element contained in this object in place.
///
@external(javascript, "./url_search_params.ffi.mjs", "for_each")
pub fn for_each(
  params: URLSearchParams,
  callback: fn(String, String) -> Nil,
) -> Nil

/// Returns a list of all keys contained in this object.
///
@external(javascript, "./url_search_params.ffi.mjs", "keys")
pub fn keys(params: URLSearchParams) -> List(String)

/// Returns a list of all values contained in this object.
///
@external(javascript, "./url_search_params.ffi.mjs", "values")
pub fn values(params: URLSearchParams) -> List(String)

/// Returns a list of all key/value pairs contained in this object.
///
@external(javascript, "./url_search_params.ffi.mjs", "entries")
pub fn entries(params: URLSearchParams) -> List(#(String, String))

/// Returns a query string suitable for use in a URL.
///
@external(javascript, "./url_search_params.ffi.mjs", "to_string")
pub fn to_string(params: URLSearchParams) -> String

/// Contains the number of search parameters.
///
@external(javascript, "./url_search_params.ffi.mjs", "size")
pub fn size(params: URLSearchParams) -> Int
