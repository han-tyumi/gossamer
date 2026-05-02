import gleam/order.{type Order}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/iterator.{type Iterator}
import gossamer/js_error.{type JsError}

/// A typed array of 8-bit unsigned integers (bytes).
///
/// See [Uint8Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array) on MDN.
///
@external(javascript, "./uint8_array.type.ts", "Uint8Array$")
pub type Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "new_")
pub fn new() -> Uint8Array

/// Creates a zero-filled `Uint8Array` of the given length. Returns an error
/// if `length` is negative or exceeds the maximum allocatable size.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(Uint8Array, JsError)

/// Creates a `Uint8Array` from a list of byte values. Values outside
/// `0`–`255` are wrapped modulo `256`, matching the JS `Uint8Array`
/// constructor — `from_list([257])` yields a one-byte array containing
/// `1`.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "from_list_mapped")
pub fn from_list_mapped(list: List(a), with mapper: fn(a) -> Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Uint8Array

/// Decodes a base64 string into a `Uint8Array`. Returns an error if
/// `string` is not valid base64.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_base64")
pub fn from_base64(string: String) -> Result(Uint8Array, JsError)

/// Decodes a hex string into a `Uint8Array`. Returns an error if `string`
/// is not valid hex (non-hex characters or odd length).
///
@external(javascript, "./uint8_array.ffi.mjs", "from_hex")
pub fn from_hex(string: String) -> Result(Uint8Array, JsError)

@external(javascript, "./uint8_array.ffi.mjs", "buffer")
pub fn buffer(of array: Uint8Array) -> ArrayBuffer

@external(javascript, "./uint8_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: Uint8Array) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: Uint8Array) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "length")
pub fn length(of array: Uint8Array) -> Int

/// Returns the byte at `index`, or `Error(Nil)` if the index is out of
/// bounds. Negative indices count from the end.
///
@external(javascript, "./uint8_array.ffi.mjs", "at")
pub fn at(array: Uint8Array, index index: Int) -> Result(Int, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "includes")
pub fn includes(in array: Uint8Array, value value: Int) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "includes_from")
pub fn includes_from(
  in array: Uint8Array,
  value value: Int,
  from index: Int,
) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_of")
pub fn index_of(in array: Uint8Array, value value: Int) -> Result(Int, Nil)

/// Like `index_of`, but starts searching from `index`.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_of_from")
pub fn index_of_from(
  in array: Uint8Array,
  value value: Int,
  from index: Int,
) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./uint8_array.ffi.mjs", "last_index_of")
pub fn last_index_of(in array: Uint8Array, value value: Int) -> Result(Int, Nil)

/// Like `last_index_of`, but searches backwards from `index`.
///
@external(javascript, "./uint8_array.ffi.mjs", "last_index_of_from")
pub fn last_index_of_from(
  in array: Uint8Array,
  value value: Int,
  from index: Int,
) -> Result(Int, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "slice")
pub fn slice(array: Uint8Array) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "slice_from")
pub fn slice_from(array: Uint8Array, start: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: Uint8Array,
  from start: Int,
  to end: Int,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "subarray")
pub fn subarray(array: Uint8Array, from begin: Int, to end: Int) -> Uint8Array

/// Copies `values` into `array` starting at index `0`. Returns an error if
/// `values` would extend past the end of `array`.
///
@external(javascript, "./uint8_array.ffi.mjs", "set")
pub fn set(
  in array: Uint8Array,
  values values: Uint8Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an error if
/// `offset` is negative or the copy would extend past the end of `array`.
///
@external(javascript, "./uint8_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Uint8Array,
  values values: Uint8Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./uint8_array.ffi.mjs", "copy_within")
pub fn copy_within(
  array: Uint8Array,
  to target: Int,
  from start: Int,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "copy_within_range")
pub fn copy_within_range(
  array: Uint8Array,
  to target: Int,
  from start: Int,
  up_to end: Int,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "fill")
pub fn fill(array: Uint8Array, with value: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "fill_range")
pub fn fill_range(
  array: Uint8Array,
  with value: Int,
  from start: Int,
  to end: Int,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "reverse")
pub fn reverse(array: Uint8Array) -> Uint8Array

/// Returns a copy of the array with the byte at `index` replaced by
/// `value`. Negative indices count from the end. Returns an error if
/// `index` is out of bounds.
///
@external(javascript, "./uint8_array.ffi.mjs", "with_")
pub fn with(
  array: Uint8Array,
  at_index index: Int,
  value value: Int,
) -> Result(Uint8Array, JsError)

@external(javascript, "./uint8_array.ffi.mjs", "join")
pub fn join(array: Uint8Array, with separator: String) -> String

@external(javascript, "./uint8_array.ffi.mjs", "every")
pub fn every(
  in array: Uint8Array,
  satisfying predicate: fn(Int) -> Bool,
) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "index_every")
pub fn index_every(
  in array: Uint8Array,
  satisfying predicate: fn(Int, Int) -> Bool,
) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "some")
pub fn some(in array: Uint8Array, satisfying predicate: fn(Int) -> Bool) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "index_some")
pub fn index_some(
  in array: Uint8Array,
  satisfying predicate: fn(Int, Int) -> Bool,
) -> Bool

/// Returns the first byte matching `predicate`, or `Error(Nil)` if none
/// match.
///
@external(javascript, "./uint8_array.ffi.mjs", "find")
pub fn find(
  in array: Uint8Array,
  one_that predicate: fn(Int) -> Bool,
) -> Result(Int, Nil)

/// Like `find`, but passes the index alongside each byte to `predicate`.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_find")
pub fn index_find(
  in array: Uint8Array,
  one_that predicate: fn(Int, Int) -> Bool,
) -> Result(Int, Nil)

/// Returns the index of the first byte matching `predicate`, or
/// `Error(Nil)` if none match.
///
@external(javascript, "./uint8_array.ffi.mjs", "find_index")
pub fn find_index(
  in array: Uint8Array,
  one_that predicate: fn(Int) -> Bool,
) -> Result(Int, Nil)

/// Like `find_index`, but passes the index alongside each byte to
/// `predicate`.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_find_index")
pub fn index_find_index(
  in array: Uint8Array,
  one_that predicate: fn(Int, Int) -> Bool,
) -> Result(Int, Nil)

/// Returns the last byte matching `predicate`, or `Error(Nil)` if none
/// match.
///
@external(javascript, "./uint8_array.ffi.mjs", "find_last")
pub fn find_last(
  in array: Uint8Array,
  one_that predicate: fn(Int) -> Bool,
) -> Result(Int, Nil)

/// Like `find_last`, but passes the index alongside each byte to
/// `predicate`.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_find_last")
pub fn index_find_last(
  in array: Uint8Array,
  one_that predicate: fn(Int, Int) -> Bool,
) -> Result(Int, Nil)

/// Returns the index of the last byte matching `predicate`, or
/// `Error(Nil)` if none match.
///
@external(javascript, "./uint8_array.ffi.mjs", "find_last_index")
pub fn find_last_index(
  in array: Uint8Array,
  one_that predicate: fn(Int) -> Bool,
) -> Result(Int, Nil)

/// Like `find_last_index`, but passes the index alongside each byte to
/// `predicate`.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_find_last_index")
pub fn index_find_last_index(
  in array: Uint8Array,
  one_that predicate: fn(Int, Int) -> Bool,
) -> Result(Int, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "filter")
pub fn filter(
  in array: Uint8Array,
  keeping predicate: fn(Int) -> Bool,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "index_filter")
pub fn index_filter(
  in array: Uint8Array,
  keeping predicate: fn(Int, Int) -> Bool,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "map")
pub fn map(over array: Uint8Array, with callback: fn(Int) -> Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "index_map")
pub fn index_map(
  over array: Uint8Array,
  with callback: fn(Int, Int) -> Int,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "for_each")
pub fn for_each(in array: Uint8Array, run callback: fn(Int) -> b) -> Nil

@external(javascript, "./uint8_array.ffi.mjs", "index_for_each")
pub fn index_for_each(
  in array: Uint8Array,
  run callback: fn(Int, Int) -> b,
) -> Nil

@external(javascript, "./uint8_array.ffi.mjs", "sort")
pub fn sort(array: Uint8Array, by compare: fn(Int, Int) -> Order) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "to_sorted")
pub fn to_sorted(
  array: Uint8Array,
  by compare: fn(Int, Int) -> Order,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "to_reversed")
pub fn to_reversed(array: Uint8Array) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "reduce")
pub fn reduce(
  over array: Uint8Array,
  from initial: a,
  with callback: fn(a, Int) -> a,
) -> a

@external(javascript, "./uint8_array.ffi.mjs", "reduce_right")
pub fn reduce_right(
  over array: Uint8Array,
  from initial: a,
  with callback: fn(a, Int) -> a,
) -> a

@external(javascript, "./uint8_array.ffi.mjs", "index_reduce")
pub fn index_reduce(
  over array: Uint8Array,
  from initial: a,
  with callback: fn(a, Int, Int) -> a,
) -> a

@external(javascript, "./uint8_array.ffi.mjs", "index_reduce_right")
pub fn index_reduce_right(
  over array: Uint8Array,
  from initial: a,
  with callback: fn(a, Int, Int) -> a,
) -> a

@external(javascript, "./uint8_array.ffi.mjs", "keys")
pub fn keys(of array: Uint8Array) -> Iterator(Int, Nil, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "values")
pub fn values(of array: Uint8Array) -> Iterator(Int, Nil, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "entries")
pub fn entries(of array: Uint8Array) -> Iterator(#(Int, Int), Nil, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "to_list")
pub fn to_list(array: Uint8Array) -> List(Int)

@external(javascript, "./uint8_array.ffi.mjs", "to_base64")
pub fn to_base64(array: Uint8Array) -> String

@external(javascript, "./uint8_array.ffi.mjs", "to_hex")
pub fn to_hex(array: Uint8Array) -> String

/// Decodes `string` as base64 into `array` in place. Returns the number
/// of characters read and bytes written. Returns an error if `string` is
/// not valid base64.
///
@external(javascript, "./uint8_array.ffi.mjs", "set_from_base64")
pub fn set_from_base64(
  array: Uint8Array,
  string: String,
) -> Result(#(Int, Int), JsError)

/// Decodes `string` as hex into `array` in place. Returns the number of
/// characters read and bytes written. Returns an error if `string` is not
/// valid hex.
///
@external(javascript, "./uint8_array.ffi.mjs", "set_from_hex")
pub fn set_from_hex(
  array: Uint8Array,
  string: String,
) -> Result(#(Int, Int), JsError)
