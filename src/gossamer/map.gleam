//// JavaScript `Map` bindings for interop with APIs that produce or
//// consume a `Map`. Treated as a transit type: bridge to
//// [`gleam/dict.Dict`](https://hexdocs.pm/gleam_stdlib/gleam/dict.html)
//// via [`to_dict`](#to_dict) and operate on the canonical Gleam
//// surface for transformations, then [`from_dict`](#from_dict) back
//// when handing off to JavaScript.

import gleam/dict.{type Dict}

/// A JavaScript `Map`, holding key-value pairs and preserving insertion
/// order. Supports any key type (unlike plain objects).
///
/// For most Gleam use cases, prefer `gleam/dict.Dict`. This binding
/// exists for interop with JavaScript code that expects a `Map`; bridge
/// with `to_dict` / `from_dict` and operate on the `Dict` surface for
/// transformations.
///
/// Object keys (records, lists, tuples) are matched by JavaScript
/// reference identity, not by Gleam value equality — two equal-by-value
/// tuples constructed separately are distinct keys. Primitive keys
/// (`Int`, `Float`, `String`, `Bool`) use value equality.
///
/// See [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) on MDN.
///
@external(javascript, "./map.type.ts", "Map$")
pub type Map(key, value)

/// Creates an empty `Map`.
///
@external(javascript, "./map.ffi.mjs", "new_")
pub fn new() -> Map(key, value)

/// Creates a `Map` from a list of key-value pairs. Later pairs override
/// earlier ones for the same key.
///
@external(javascript, "./map.ffi.mjs", "from_list")
pub fn from_list(entries: List(#(key, value))) -> Map(key, value)

/// Creates a `Map` from a `Dict`. Iteration order follows the `Dict`'s
/// `to_list` order.
///
@external(javascript, "./map.ffi.mjs", "from_dict")
pub fn from_dict(dict: Dict(key, value)) -> Map(key, value)

/// Converts the `Map` to a `Dict`. Iteration order is preserved as
/// `Dict` insertion order.
///
@external(javascript, "./map.ffi.mjs", "to_dict")
pub fn to_dict(map: Map(key, value)) -> Dict(key, value)
