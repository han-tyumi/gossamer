//// Extras for `gleam/javascript/symbol` — no-description constructor
//// and registry-key lookup not exposed upstream.

import gleam/javascript/symbol.{type Symbol}

/// Creates a symbol with no description. Distinct from
/// `symbol.new("")`, which sets the description to the empty string.
/// Equivalent to JavaScript's `Symbol()` (called with no argument).
///
/// ## Examples
///
/// ```gleam
/// let s = symbol_extra.anonymous()
/// symbol.description(s)
/// // -> Error(Nil)
/// ```
///
@external(javascript, "./symbol_extra.ffi.mjs", "anonymous")
pub fn anonymous() -> Symbol

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
