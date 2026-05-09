//// Extras for `gleam/javascript/symbol` — no-description constructor,
//// registry-key lookup, and string conversion not exposed upstream.

import gleam/javascript/symbol.{type Symbol}

/// Creates a new symbol with no description. Distinct from
/// `symbol.new("")`, which sets the description to the empty string.
///
/// ## Examples
///
/// ```gleam
/// let s = symbol_extra.new()
/// symbol.description(s)
/// // -> Error(Nil)
/// ```
///
@external(javascript, "./symbol_extra.ffi.mjs", "new_")
pub fn new() -> Symbol

/// The registry key for a global symbol. Returns an error if `symbol`
/// is not in the global registry.
///
/// ## Examples
///
/// ```gleam
/// let s = symbol.get_or_create_global("my.key")
/// symbol_extra.key_for(s)
/// // -> Ok("my.key")
/// ```
///
@external(javascript, "./symbol_extra.ffi.mjs", "key_for")
pub fn key_for(symbol: Symbol) -> Result(String, Nil)

/// The symbol's string representation.
///
/// ## Examples
///
/// ```gleam
/// let s = symbol.new("test")
/// symbol_extra.to_string(s)
/// // -> "Symbol(test)"
/// ```
///
@external(javascript, "./symbol_extra.ffi.mjs", "to_string")
pub fn to_string(symbol: Symbol) -> String
