/// A unique, immutable primitive value. Two symbols are never equal, even
/// if created with the same description.
///
/// See [Symbol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) on MDN.
///
@external(javascript, "./symbol.type.ts", "Symbol$")
pub type Symbol

@external(javascript, "./symbol.ffi.mjs", "new_")
pub fn new() -> Symbol

@external(javascript, "./symbol.ffi.mjs", "new_with")
pub fn new_with(description description: String) -> Symbol

/// Returns a symbol from the global registry for the given key, creating one
/// if it does not already exist.
///
@external(javascript, "./symbol.ffi.mjs", "for_")
pub fn for(key: String) -> Symbol

/// Returns the registry key for a global symbol. Returns an error if the
/// symbol is not in the global registry.
///
@external(javascript, "./symbol.ffi.mjs", "key_for")
pub fn key_for(symbol: Symbol) -> Result(String, Nil)

/// Returns the description of a symbol, or an error if it has none.
///
@external(javascript, "./symbol.ffi.mjs", "description")
pub fn description(of symbol: Symbol) -> Result(String, Nil)

@external(javascript, "./symbol.ffi.mjs", "to_string")
pub fn to_string(symbol: Symbol) -> String
