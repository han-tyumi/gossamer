import gleam/dict.{type Dict}
import gleam/yielder.{type Yielder}

/// A JS `Map` holding key-value pairs. Supports any key type (unlike
/// plain objects) and preserves insertion order.
///
/// For most Gleam use cases, prefer `gleam/dict.Dict`. This binding
/// exists for JS interop where a JS `Map` is specifically required.
/// Bridge with `to_dict` / `from_dict` and operate on the `Dict`
/// surface for transformations.
///
/// Object keys (records, lists, tuples) are matched by JS reference
/// identity, not value equality — two equal-by-value tuples constructed
/// separately are distinct keys. Primitive keys (`Int`, `Float`,
/// `String`, `Bool`) use value equality.
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
pub fn to_dict(map: Map(key, value)) -> Dict(key, value) {
  yielder.fold(entries(map), dict.new(), fn(acc, entry) {
    let #(key, value) = entry
    dict.insert(acc, key, value)
  })
}

/// The number of entries in the `Map`.
///
@external(javascript, "./map.ffi.mjs", "size")
pub fn size(of map: Map(key, value)) -> Int

/// Returns the value associated with the given key, or `Error(Nil)` if
/// the key is absent.
///
@external(javascript, "./map.ffi.mjs", "get")
pub fn get(from map: Map(key, value), key key: key) -> Result(value, Nil)

/// Returns whether the `Map` contains the given key.
///
@external(javascript, "./map.ffi.mjs", "has")
pub fn has(in map: Map(key, value), key key: key) -> Bool

/// Returns the keys of the `Map` in insertion order.
///
@external(javascript, "./map.ffi.mjs", "keys")
pub fn keys(of map: Map(key, value)) -> Yielder(key)

/// Returns the values of the `Map` in insertion order.
///
@external(javascript, "./map.ffi.mjs", "values")
pub fn values(of map: Map(key, value)) -> Yielder(value)

/// Returns the `#(key, value)` pairs of the `Map` in insertion order.
///
@external(javascript, "./map.ffi.mjs", "entries")
pub fn entries(of map: Map(key, value)) -> Yielder(#(key, value))
