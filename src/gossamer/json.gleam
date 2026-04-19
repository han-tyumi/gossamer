import gleam/dict.{type Dict}

/// A JSON value — one of null, boolean, number, string, array, or object.
///
pub type Json {
  Null
  Boolean(Bool)
  Number(Float)
  String(String)
  Array(List(Json))
  Object(Dict(String, Json))
}

/// Parses a JSON string into a `Json` value. Returns an error if the
/// string is not valid JSON.
///
@external(javascript, "./json.ffi.mjs", "parse")
pub fn parse(text: String) -> Result(Json, String)

/// Serializes a `Json` value into a JSON string.
///
@external(javascript, "./json.ffi.mjs", "stringify")
pub fn stringify(json: Json) -> String
