//// JavaScript `Set` bindings for interop with APIs that produce or
//// consume a `Set`. Treated as a transit type: bridge to
//// [`gleam/set.Set`](https://hexdocs.pm/gleam_stdlib/gleam/set.html)
//// via [`to_set`](#to_set) and operate on the canonical Gleam surface
//// for transformations, then [`from_set`](#from_set) back when handing
//// off to JavaScript. The non-mutating reads ([`size`](#size),
//// [`has`](#has), [`values`](#values)) stay for one-shot interop
//// without round-tripping through `gleam/set.Set`.

import gleam/set
import gleam/yielder.{type Yielder}

/// A JavaScript `Set`, holding unique values of any type and preserving
/// insertion order.
///
/// For most Gleam use cases, prefer `gleam/set.Set`. This binding exists
/// for interop with JavaScript code that expects a `Set`; bridge with
/// `to_set` / `from_set` and operate on the `gleam/set.Set` surface for
/// transformations.
///
/// Object values (records, lists, tuples) are matched by JavaScript
/// reference identity, not by Gleam value equality — two equal-by-value
/// tuples constructed separately are distinct values. Primitive values
/// (`Int`, `Float`, `String`, `Bool`) use value equality.
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
@external(javascript, "./set.ffi.mjs", "to_set")
pub fn to_set(set: Set(value)) -> set.Set(value)

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
