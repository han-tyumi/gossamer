import gleam/set
import gleam/yielder.{type Yielder}

/// A JS `Set` holding unique values of any type, preserving insertion
/// order.
///
/// For most Gleam use cases, prefer `gleam/set.Set`. This binding exists
/// for JS interop where a JS `Set` is specifically required. Bridge
/// with `to_set` / `from_set` and operate on the `Set` surface for
/// transformations.
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

/// Creates an empty `Set`.
///
@external(javascript, "./set.ffi.mjs", "new_")
pub fn new() -> Set(value)

/// Creates a `Set` from a list of values. Duplicate values appear once.
///
@external(javascript, "./set.ffi.mjs", "from_list")
pub fn from_list(values: List(value)) -> Set(value)

/// Creates a `Set` from a `gleam/set.Set`.
///
@external(javascript, "./set.ffi.mjs", "from_set")
pub fn from_set(set: set.Set(value)) -> Set(value)

/// Converts the `Set` to a `gleam/set.Set`. Insertion order is
/// preserved as `gleam/set.Set` insertion order.
///
pub fn to_set(set: Set(value)) -> set.Set(value) {
  yielder.fold(values(set), set.new(), fn(acc, value) { set.insert(acc, value) })
}

/// The number of values in the `Set`.
///
@external(javascript, "./set.ffi.mjs", "size")
pub fn size(set: Set(value)) -> Int

/// Returns whether the `Set` contains the given value.
///
@external(javascript, "./set.ffi.mjs", "has")
pub fn has(in set: Set(value), value value: value) -> Bool

/// Returns the values of the `Set` in insertion order.
///
@external(javascript, "./set.ffi.mjs", "values")
pub fn values(set: Set(value)) -> Yielder(value)

/// Returns the `#(value, value)` pairs of the `Set` in insertion order.
/// Each value appears with itself, mirroring the JS `Set.entries()`
/// shape.
///
@external(javascript, "./set.ffi.mjs", "entries")
pub fn entries(set: Set(value)) -> Yielder(#(value, value))
