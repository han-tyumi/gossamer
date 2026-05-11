import gossamer/weak.{type WeakKeyError}

/// A JS `WeakSet` whose values are weakly held — entries are eligible
/// for GC once the value has no other references. Mutable.
///
/// Values must be objects (records, lists, tuples) or non-registered
/// symbols (those not in the global registry); `add` and `from_list`
/// return `InvalidTarget` otherwise. Has no `size`, iteration, or
/// `clear` (those would expose GC timing).
///
/// Values are matched by JS reference identity, not value equality —
/// two equal-by-value tuples constructed separately are distinct
/// values.
///
/// See [WeakSet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakSet) on MDN.
///
@external(javascript, "./weak_set.type.ts", "WeakSet$")
pub type WeakSet(value)

@external(javascript, "./weak_set.ffi.mjs", "new_")
pub fn new() -> WeakSet(value)

/// Returns `InvalidTarget` if any value in `values` is not a valid
/// weak key.
///
@external(javascript, "./weak_set.ffi.mjs", "from_list")
pub fn from_list(values: List(value)) -> Result(WeakSet(value), WeakKeyError)

@external(javascript, "./weak_set.ffi.mjs", "has")
pub fn has(in set: WeakSet(value), value value: value) -> Bool

/// Mutates the set. Returns `InvalidTarget` if `value` is not a valid
/// weak key.
///
@external(javascript, "./weak_set.ffi.mjs", "add")
pub fn add(
  to set: WeakSet(value),
  value value: value,
) -> Result(WeakSet(value), WeakKeyError)

/// Mutates the set.
///
@external(javascript, "./weak_set.ffi.mjs", "delete_")
pub fn delete(from set: WeakSet(value), value value: value) -> WeakSet(value)
