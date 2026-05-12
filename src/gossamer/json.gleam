//// A transparent `Json` ADT for inspecting or pattern-matching on JSON
//// of unknown structure. For typed encode/decode pipelines, use
//// `gleam_json`.

import gleam/dict.{type Dict}

/// A JSON value.
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
/// string is not valid JSON per the
/// [ECMA-404](https://www.ecma-international.org/publications-and-standards/standards/ecma-404/)
/// grammar.
///
@external(javascript, "./json.ffi.mjs", "parse")
pub fn parse(text: String) -> Result(Json, Nil)

/// Serializes a `Json` value into a JSON string.
///
@external(javascript, "./json.ffi.mjs", "stringify")
pub fn stringify(json: Json) -> String
