import gossamer/js_error.{type JsError}

/// A JS `WeakSet` whose values are weakly held — entries are eligible
/// for GC once the value has no other references. Mutable.
///
/// Values must be objects (records, lists, tuples) or non-registered
/// symbols (`gossamer/symbol.new`, not `gossamer/symbol.for`); `add`
/// and `from_list` return an error otherwise. Has no `size`,
/// iteration, or `clear` (those would expose GC timing).
///
/// See [WeakSet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakSet) on MDN.
///
@external(javascript, "./weak_set.type.ts", "WeakSet$")
pub type WeakSet(value)

@external(javascript, "./weak_set.ffi.mjs", "new_")
pub fn new() -> WeakSet(value)

/// Returns an error if any value in `values` is invalid.
///
@external(javascript, "./weak_set.ffi.mjs", "from_list")
pub fn from_list(values: List(value)) -> Result(WeakSet(value), JsError)

@external(javascript, "./weak_set.ffi.mjs", "has")
pub fn has(in set: WeakSet(value), value value: value) -> Bool

/// Mutates the set. Returns an error if `value` is invalid.
///
@external(javascript, "./weak_set.ffi.mjs", "add")
pub fn add(
  to set: WeakSet(value),
  value value: value,
) -> Result(WeakSet(value), JsError)

/// Mutates the set.
///
@external(javascript, "./weak_set.ffi.mjs", "delete_")
pub fn delete(from set: WeakSet(value), value value: value) -> WeakSet(value)
