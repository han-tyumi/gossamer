import gossamer/iterator.{type Iterator}

/// A JS `Set` holding unique values of any type, preserving insertion
/// order. Mutable — methods modify the set in place and return it for
/// chaining.
///
/// For most Gleam use cases, prefer `gleam/set.Set`. This binding exists
/// for JS interop where a JS `Set` is specifically required.
///
/// Object values (records, lists, tuples) are matched by JS reference
/// identity, not value equality — two equal-by-value tuples constructed
/// separately are distinct values. Primitive values (`Int`, `Float`,
/// `String`, `Bool`) use value equality.
///
/// See [Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set) on MDN.
///
@external(javascript, "./set.type.ts", "Set$")
pub type Set(value)

@external(javascript, "./set.ffi.mjs", "new_")
pub fn new() -> Set(value)

@external(javascript, "./set.ffi.mjs", "from_list")
pub fn from_list(values: List(value)) -> Set(value)

@external(javascript, "./set.ffi.mjs", "size")
pub fn size(of set: Set(value)) -> Int

/// Adds a value to the set. Mutates the set.
///
@external(javascript, "./set.ffi.mjs", "add")
pub fn add(to set: Set(value), value value: value) -> Set(value)

@external(javascript, "./set.ffi.mjs", "has")
pub fn has(in set: Set(value), value value: value) -> Bool

/// Removes the value from the set. Mutates the set.
///
@external(javascript, "./set.ffi.mjs", "delete_")
pub fn delete(from set: Set(value), value value: value) -> Set(value)

/// Removes all values. Mutates the set.
///
@external(javascript, "./set.ffi.mjs", "clear")
pub fn clear(set: Set(value)) -> Set(value)

@external(javascript, "./set.ffi.mjs", "values")
pub fn values(of set: Set(value)) -> Iterator(value, Nil, Nil)

@external(javascript, "./set.ffi.mjs", "entries")
pub fn entries(of set: Set(value)) -> Iterator(#(value, value), Nil, Nil)

@external(javascript, "./set.ffi.mjs", "for_each")
pub fn for_each(in set: Set(value), run callback: fn(value) -> a) -> Nil

/// Returns a new set containing values in this set but not in the other.
///
@external(javascript, "./set.ffi.mjs", "difference")
pub fn difference(from set: Set(value), without other: Set(value)) -> Set(value)

/// Returns a new set containing values present in both sets.
///
@external(javascript, "./set.ffi.mjs", "intersection")
pub fn intersection(of set: Set(value), and other: Set(value)) -> Set(value)

/// Returns a new set containing all values from both sets.
///
@external(javascript, "./set.ffi.mjs", "union")
pub fn union(of set: Set(value), and other: Set(value)) -> Set(value)

/// Returns a new set containing values in either set but not both.
///
@external(javascript, "./set.ffi.mjs", "symmetric_difference")
pub fn symmetric_difference(
  of set: Set(value),
  and other: Set(value),
) -> Set(value)

@external(javascript, "./set.ffi.mjs", "is_disjoint_from")
pub fn is_disjoint_from(set: Set(value), other: Set(value)) -> Bool

@external(javascript, "./set.ffi.mjs", "is_subset_of")
pub fn is_subset_of(set: Set(value), other: Set(value)) -> Bool

@external(javascript, "./set.ffi.mjs", "is_superset_of")
pub fn is_superset_of(set: Set(value), other: Set(value)) -> Bool
