import gossamer/weak.{type WeakKeyError}

/// A JavaScript `WeakMap` whose keys are weakly held — entries are
/// eligible for GC once the key has no other references. Mutable.
///
/// Keys must be objects (records, lists, tuples) or non-registered
/// symbols (those not in the global registry); `set` and `from_list`
/// return `InvalidTarget` otherwise. Has no `size`, iteration, or
/// `clear` (those would expose GC timing).
///
/// Keys are matched by JavaScript reference identity, not by Gleam
/// value equality — two equal-by-value tuples constructed separately
/// are distinct keys.
///
/// See [WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap) on MDN.
///
@external(javascript, "./weak_map.type.ts", "WeakMap$")
pub type WeakMap(key, value)

@external(javascript, "./weak_map.ffi.mjs", "new_")
pub fn new() -> WeakMap(key, value)

/// Returns `InvalidTarget` if any key in `entries` is not a valid weak
/// key.
///
@external(javascript, "./weak_map.ffi.mjs", "from_list")
pub fn from_list(
  entries: List(#(key, value)),
) -> Result(WeakMap(key, value), WeakKeyError)

/// Returns the value associated with the given key, or an error if not
/// found.
///
@external(javascript, "./weak_map.ffi.mjs", "get")
pub fn get(from map: WeakMap(key, value), key key: key) -> Result(value, Nil)

@external(javascript, "./weak_map.ffi.mjs", "has")
pub fn has(in map: WeakMap(key, value), key key: key) -> Bool

/// Mutates the map. Returns `InvalidTarget` if `key` is not a valid
/// weak key.
///
@external(javascript, "./weak_map.ffi.mjs", "set")
pub fn set(
  in map: WeakMap(key, value),
  key key: key,
  value value: value,
) -> Result(WeakMap(key, value), WeakKeyError)

/// Mutates the map.
///
@external(javascript, "./weak_map.ffi.mjs", "delete_")
pub fn delete(
  from map: WeakMap(key, value),
  key key: key,
) -> WeakMap(key, value)
