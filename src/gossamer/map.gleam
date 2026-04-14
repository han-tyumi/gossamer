@external(javascript, "./map.type.ts", "Map$")
pub type Map(key, value)

@external(javascript, "./map.ffi.mjs", "new_")
pub fn new() -> Map(key, value)

@external(javascript, "./map.ffi.mjs", "from_list")
pub fn from_list(entries: List(#(key, value))) -> Map(key, value)

@external(javascript, "./map.ffi.mjs", "size")
pub fn size(of map: Map(key, value)) -> Int

/// Returns the value associated with the given key, or an error if not found.
///
@external(javascript, "./map.ffi.mjs", "get")
pub fn get(from map: Map(key, value), key key: key) -> Result(value, Nil)

@external(javascript, "./map.ffi.mjs", "has")
pub fn has(in map: Map(key, value), key key: key) -> Bool

/// Sets the value for the given key. Mutates the map.
///
@external(javascript, "./map.ffi.mjs", "set")
pub fn set(
  in map: Map(key, value),
  key key: key,
  value value: value,
) -> Map(key, value)

/// Returns whether the key existed before removal.
///
@external(javascript, "./map.ffi.mjs", "delete_")
pub fn delete(from map: Map(key, value), key key: key) -> Bool

/// Removes all entries. Mutates the map.
///
@external(javascript, "./map.ffi.mjs", "clear")
pub fn clear(map: Map(key, value)) -> Map(key, value)

@external(javascript, "./map.ffi.mjs", "keys")
pub fn keys(of map: Map(key, value)) -> List(key)

@external(javascript, "./map.ffi.mjs", "values")
pub fn values(of map: Map(key, value)) -> List(value)

@external(javascript, "./map.ffi.mjs", "entries")
pub fn entries(of map: Map(key, value)) -> List(#(key, value))

@external(javascript, "./map.ffi.mjs", "for_each")
pub fn for_each(
  in map: Map(key, value),
  run callback: fn(value, key) -> a,
) -> Nil
