import gleam/order.{type Order}
import gossamer/iterator.{type Iterator}

/// A JS `Array` — an indexed, ordered, mutable list of values.
///
/// For most Gleam use cases, prefer `List`. This binding exists for JS
/// interop where a JS `Array` is specifically required.
///
/// See [Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array) on MDN.
///
@external(javascript, "./array.type.ts", "Array$")
pub type Array(a)

@external(javascript, "./array.ffi.mjs", "new_")
pub fn new() -> Array(a)

@external(javascript, "./array.ffi.mjs", "from_list")
pub fn from_list(list: List(a)) -> Array(a)

@external(javascript, "./array.ffi.mjs", "from_list_mapped")
pub fn from_list_mapped(list: List(a), with mapper: fn(a) -> b) -> Array(b)

@external(javascript, "./array.ffi.mjs", "length")
pub fn length(of array: Array(a)) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is out of
/// range. Negative indices count from the end.
///
@external(javascript, "./array.ffi.mjs", "at")
pub fn at(array: Array(a), index index: Int) -> Result(a, Nil)

@external(javascript, "./array.ffi.mjs", "includes")
pub fn includes(in array: Array(a), value value: a) -> Bool

@external(javascript, "./array.ffi.mjs", "includes_from")
pub fn includes_from(
  in array: Array(a),
  value value: a,
  from index: Int,
) -> Bool

/// Returns the first index of `value` in the array, or `Error(Nil)` if the
/// value is not found.
///
@external(javascript, "./array.ffi.mjs", "index_of")
pub fn index_of(in array: Array(a), value value: a) -> Result(Int, Nil)

/// Like `index_of`, but starts searching from `index`.
///
@external(javascript, "./array.ffi.mjs", "index_of_from")
pub fn index_of_from(
  in array: Array(a),
  value value: a,
  from index: Int,
) -> Result(Int, Nil)

/// Returns the last index of `value` in the array, or `Error(Nil)` if the
/// value is not found.
///
@external(javascript, "./array.ffi.mjs", "last_index_of")
pub fn last_index_of(in array: Array(a), value value: a) -> Result(Int, Nil)

/// Like `last_index_of`, but searches backwards from `index`.
///
@external(javascript, "./array.ffi.mjs", "last_index_of_from")
pub fn last_index_of_from(
  in array: Array(a),
  value value: a,
  from index: Int,
) -> Result(Int, Nil)

/// Returns the first value matching `predicate`, or `Error(Nil)` if none
/// match.
///
@external(javascript, "./array.ffi.mjs", "find")
pub fn find(
  in array: Array(a),
  one_that predicate: fn(a) -> Bool,
) -> Result(a, Nil)

/// Like `find`, but passes the index alongside each value to `predicate`.
///
@external(javascript, "./array.ffi.mjs", "index_find")
pub fn index_find(
  in array: Array(a),
  one_that predicate: fn(a, Int) -> Bool,
) -> Result(a, Nil)

/// Returns the index of the first value matching `predicate`, or
/// `Error(Nil)` if none match.
///
@external(javascript, "./array.ffi.mjs", "find_index")
pub fn find_index(
  in array: Array(a),
  one_that predicate: fn(a) -> Bool,
) -> Result(Int, Nil)

/// Like `find_index`, but passes the index alongside each value to
/// `predicate`.
///
@external(javascript, "./array.ffi.mjs", "index_find_index")
pub fn index_find_index(
  in array: Array(a),
  one_that predicate: fn(a, Int) -> Bool,
) -> Result(Int, Nil)

/// Returns the last value matching `predicate`, or `Error(Nil)` if none
/// match.
///
@external(javascript, "./array.ffi.mjs", "find_last")
pub fn find_last(
  in array: Array(a),
  one_that predicate: fn(a) -> Bool,
) -> Result(a, Nil)

/// Like `find_last`, but passes the index alongside each value to
/// `predicate`.
///
@external(javascript, "./array.ffi.mjs", "index_find_last")
pub fn index_find_last(
  in array: Array(a),
  one_that predicate: fn(a, Int) -> Bool,
) -> Result(a, Nil)

/// Returns the index of the last value matching `predicate`, or
/// `Error(Nil)` if none match.
///
@external(javascript, "./array.ffi.mjs", "find_last_index")
pub fn find_last_index(
  in array: Array(a),
  one_that predicate: fn(a) -> Bool,
) -> Result(Int, Nil)

/// Like `find_last_index`, but passes the index alongside each value to
/// `predicate`.
///
@external(javascript, "./array.ffi.mjs", "index_find_last_index")
pub fn index_find_last_index(
  in array: Array(a),
  one_that predicate: fn(a, Int) -> Bool,
) -> Result(Int, Nil)

@external(javascript, "./array.ffi.mjs", "every")
pub fn every(in array: Array(a), satisfying predicate: fn(a) -> Bool) -> Bool

@external(javascript, "./array.ffi.mjs", "index_every")
pub fn index_every(
  in array: Array(a),
  satisfying predicate: fn(a, Int) -> Bool,
) -> Bool

@external(javascript, "./array.ffi.mjs", "some")
pub fn some(in array: Array(a), satisfying predicate: fn(a) -> Bool) -> Bool

@external(javascript, "./array.ffi.mjs", "index_some")
pub fn index_some(
  in array: Array(a),
  satisfying predicate: fn(a, Int) -> Bool,
) -> Bool

@external(javascript, "./array.ffi.mjs", "slice")
pub fn slice(array: Array(a)) -> Array(a)

@external(javascript, "./array.ffi.mjs", "slice_from")
pub fn slice_from(array: Array(a), start: Int) -> Array(a)

@external(javascript, "./array.ffi.mjs", "slice_range")
pub fn slice_range(array: Array(a), from start: Int, to end: Int) -> Array(a)

@external(javascript, "./array.ffi.mjs", "map")
pub fn map(over array: Array(a), with callback: fn(a) -> b) -> Array(b)

@external(javascript, "./array.ffi.mjs", "index_map")
pub fn index_map(
  over array: Array(a),
  with callback: fn(a, Int) -> b,
) -> Array(b)

@external(javascript, "./array.ffi.mjs", "filter")
pub fn filter(in array: Array(a), keeping predicate: fn(a) -> Bool) -> Array(a)

@external(javascript, "./array.ffi.mjs", "index_filter")
pub fn index_filter(
  in array: Array(a),
  keeping predicate: fn(a, Int) -> Bool,
) -> Array(a)

@external(javascript, "./array.ffi.mjs", "flat")
pub fn flat(array: Array(Array(a))) -> Array(a)

@external(javascript, "./array.ffi.mjs", "flat_map")
pub fn flat_map(
  over array: Array(a),
  with callback: fn(a) -> Array(b),
) -> Array(b)

@external(javascript, "./array.ffi.mjs", "concat")
pub fn concat(array: Array(a), and other: Array(a)) -> Array(a)

@external(javascript, "./array.ffi.mjs", "to_reversed")
pub fn to_reversed(array: Array(a)) -> Array(a)

@external(javascript, "./array.ffi.mjs", "to_sorted")
pub fn to_sorted(array: Array(a), by compare: fn(a, a) -> Order) -> Array(a)

@external(javascript, "./array.ffi.mjs", "with_")
pub fn with(array: Array(a), at_index index: Int, value value: a) -> Array(a)

@external(javascript, "./array.ffi.mjs", "to_spliced")
pub fn to_spliced(
  array: Array(a),
  from start: Int,
  removing count: Int,
) -> Array(a)

@external(javascript, "./array.ffi.mjs", "to_spliced_with")
pub fn to_spliced_with(
  array: Array(a),
  from start: Int,
  removing count: Int,
  inserting items: List(a),
) -> Array(a)

@external(javascript, "./array.ffi.mjs", "push")
pub fn push(to array: Array(a), value value: a) -> Array(a)

@external(javascript, "./array.ffi.mjs", "unshift")
pub fn unshift(to array: Array(a), value value: a) -> Array(a)

@external(javascript, "./array.ffi.mjs", "reverse")
pub fn reverse(array: Array(a)) -> Array(a)

@external(javascript, "./array.ffi.mjs", "sort")
pub fn sort(array: Array(a), by compare: fn(a, a) -> Order) -> Array(a)

@external(javascript, "./array.ffi.mjs", "fill")
pub fn fill(array: Array(a), with value: a) -> Array(a)

@external(javascript, "./array.ffi.mjs", "fill_range")
pub fn fill_range(
  array: Array(a),
  with value: a,
  from start: Int,
  to end: Int,
) -> Array(a)

@external(javascript, "./array.ffi.mjs", "copy_within")
pub fn copy_within(array: Array(a), to target: Int, from start: Int) -> Array(a)

@external(javascript, "./array.ffi.mjs", "copy_within_range")
pub fn copy_within_range(
  array: Array(a),
  to target: Int,
  from start: Int,
  up_to end: Int,
) -> Array(a)

/// Returns the removed element, or an error if the array is empty.
///
@external(javascript, "./array.ffi.mjs", "pop")
pub fn pop(from array: Array(a)) -> Result(a, Nil)

/// Returns the removed element, or an error if the array is empty.
///
@external(javascript, "./array.ffi.mjs", "shift")
pub fn shift(from array: Array(a)) -> Result(a, Nil)

/// Removes elements and returns them. Mutates the array.
///
@external(javascript, "./array.ffi.mjs", "splice")
pub fn splice(
  in array: Array(a),
  from start: Int,
  removing count: Int,
) -> Array(a)

/// Removes elements, inserts new ones, and returns the removed elements.
/// Mutates the array.
///
@external(javascript, "./array.ffi.mjs", "splice_with")
pub fn splice_with(
  in array: Array(a),
  from start: Int,
  removing count: Int,
  inserting items: List(a),
) -> Array(a)

@external(javascript, "./array.ffi.mjs", "for_each")
pub fn for_each(in array: Array(a), run callback: fn(a) -> b) -> Nil

@external(javascript, "./array.ffi.mjs", "index_for_each")
pub fn index_for_each(in array: Array(a), run callback: fn(a, Int) -> b) -> Nil

@external(javascript, "./array.ffi.mjs", "reduce")
pub fn reduce(
  over array: Array(a),
  from initial: b,
  with callback: fn(b, a) -> b,
) -> b

@external(javascript, "./array.ffi.mjs", "reduce_right")
pub fn reduce_right(
  over array: Array(a),
  from initial: b,
  with callback: fn(b, a) -> b,
) -> b

@external(javascript, "./array.ffi.mjs", "index_reduce")
pub fn index_reduce(
  over array: Array(a),
  from initial: b,
  with callback: fn(b, a, Int) -> b,
) -> b

@external(javascript, "./array.ffi.mjs", "index_reduce_right")
pub fn index_reduce_right(
  over array: Array(a),
  from initial: b,
  with callback: fn(b, a, Int) -> b,
) -> b

@external(javascript, "./array.ffi.mjs", "join")
pub fn join(array: Array(a), with separator: String) -> String

@external(javascript, "./array.ffi.mjs", "to_string")
pub fn to_string(array: Array(a)) -> String

@external(javascript, "./array.ffi.mjs", "to_list")
pub fn to_list(array: Array(a)) -> List(a)

@external(javascript, "./array.ffi.mjs", "keys")
pub fn keys(of array: Array(a)) -> Iterator(Int, Nil, Nil)

@external(javascript, "./array.ffi.mjs", "values")
pub fn values(of array: Array(a)) -> Iterator(a, Nil, Nil)

@external(javascript, "./array.ffi.mjs", "entries")
pub fn entries(of array: Array(a)) -> Iterator(#(Int, a), Nil, Nil)
