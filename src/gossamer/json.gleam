//// A transparent `Json` type for inspecting or pattern-matching on JSON
//// of unknown structure. For typed encode/decode pipelines, use
//// `gleam_json`.

import gleam/dict.{type Dict}

/// A JSON value.
///
pub type Json {
  /// The JSON `null` literal.
  Null

  /// A JSON boolean — `true` or `false`.
  Boolean(Bool)

  /// A JSON number. JSON has no distinction between integers and floats;
  /// all numeric values are decoded as `Float`.
  Number(Float)

  /// A JSON string.
  String(String)

  /// A JSON array — an ordered sequence of values.
  Array(List(Json))

  /// A JSON object — a string-keyed map of values.
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
