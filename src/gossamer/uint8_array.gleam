import gossamer/array_buffer.{type ArrayBuffer}
import gleam/option.{type Option}
import gleam/order.{type Order}

/// A typed array of 8-bit unsigned integer values. The contents are initialized
/// to 0. If the requested number of bytes could not be allocated an exception
/// is raised.
///
@external(javascript, "./uint8_array.type.ts", "Uint8Array$")
pub type Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "new_")
pub fn new() -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Uint8Array

/// Creates a new `Uint8Array` from a base64-encoded string.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_base64")
pub fn from_base64(string: String) -> Uint8Array

/// Creates a new `Uint8Array` from a base16-encoded string.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_hex")
pub fn from_hex(string: String) -> Uint8Array

/// The ArrayBuffer instance referenced by the array.
///
@external(javascript, "./uint8_array.ffi.mjs", "buffer")
pub fn buffer(array: Uint8Array) -> ArrayBuffer

/// The length in bytes of the array.
///
@external(javascript, "./uint8_array.ffi.mjs", "byte_length")
pub fn byte_length(array: Uint8Array) -> Int

/// The offset in bytes of the array.
///
@external(javascript, "./uint8_array.ffi.mjs", "byte_offset")
pub fn byte_offset(array: Uint8Array) -> Int

/// The length of the array.
///
@external(javascript, "./uint8_array.ffi.mjs", "length")
pub fn length(array: Uint8Array) -> Int

/// Returns the item located at the specified index. A negative index will
/// count back from the last item.
///
@external(javascript, "./uint8_array.ffi.mjs", "at")
pub fn at(array: Uint8Array, index: Int) -> Option(Int)

/// Determines whether an array includes a certain element, returning true or
/// false as appropriate.
///
@external(javascript, "./uint8_array.ffi.mjs", "includes")
pub fn includes(array: Uint8Array, value: Int) -> Bool

/// Determines whether an array includes a certain element, searching from the
/// given index.
///
@external(javascript, "./uint8_array.ffi.mjs", "includes_from")
pub fn includes_from(array: Uint8Array, value: Int, from_index: Int) -> Bool

/// Returns the index of the first occurrence of a value in an array.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_of")
pub fn index_of(array: Uint8Array, value: Int) -> Int

/// Returns the index of the first occurrence of a value in an array, searching
/// from the given index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_of_from")
pub fn index_of_from(array: Uint8Array, value: Int, from_index: Int) -> Int

/// Returns the index of the last occurrence of a value in an array.
///
@external(javascript, "./uint8_array.ffi.mjs", "last_index_of")
pub fn last_index_of(array: Uint8Array, value: Int) -> Int

/// Returns the index of the last occurrence of a value in an array, searching
/// from the given index.
///
@external(javascript, "./uint8_array.ffi.mjs", "last_index_of_from")
pub fn last_index_of_from(array: Uint8Array, value: Int, from_index: Int) -> Int

/// Returns a section of an array.
///
@external(javascript, "./uint8_array.ffi.mjs", "slice")
pub fn slice(array: Uint8Array) -> Uint8Array

/// Returns a section of an array starting from the given index.
///
@external(javascript, "./uint8_array.ffi.mjs", "slice_from")
pub fn slice_from(array: Uint8Array, start: Int) -> Uint8Array

/// Returns a section of an array from start to end (exclusive).
///
@external(javascript, "./uint8_array.ffi.mjs", "slice_range")
pub fn slice_range(array: Uint8Array, start: Int, end: Int) -> Uint8Array

/// Gets a new Uint8Array view of the ArrayBuffer store for this array,
/// referencing the elements at begin, inclusive, up to end, exclusive.
///
@external(javascript, "./uint8_array.ffi.mjs", "subarray")
pub fn subarray(array: Uint8Array, begin: Int, end: Int) -> Uint8Array

/// Sets a value or an array of values.
///
@external(javascript, "./uint8_array.ffi.mjs", "set")
pub fn set(array: Uint8Array, values: Uint8Array) -> Nil

/// Sets a value or an array of values starting at the given offset.
///
@external(javascript, "./uint8_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  array: Uint8Array,
  values: Uint8Array,
  offset: Int,
) -> Nil

/// Returns the this object after copying a section of the array identified by
/// start and end to the same array starting at position target.
///
@external(javascript, "./uint8_array.ffi.mjs", "copy_within")
pub fn copy_within(array: Uint8Array, target: Int, start: Int) -> Uint8Array

/// Returns the this object after copying a section of the array identified by
/// start and end to the same array starting at position target.
///
@external(javascript, "./uint8_array.ffi.mjs", "copy_within_range")
pub fn copy_within_range(
  array: Uint8Array,
  target: Int,
  start: Int,
  end: Int,
) -> Uint8Array

/// Changes all array elements from `start` to `end` index to a static `value`
/// and returns the modified array.
///
@external(javascript, "./uint8_array.ffi.mjs", "fill")
pub fn fill(array: Uint8Array, value: Int) -> Uint8Array

/// Changes array elements from `start` to `end` index to a static `value`
/// and returns the modified array.
///
@external(javascript, "./uint8_array.ffi.mjs", "fill_range")
pub fn fill_range(
  array: Uint8Array,
  value: Int,
  start: Int,
  end: Int,
) -> Uint8Array

/// Reverses the elements in an Array.
///
@external(javascript, "./uint8_array.ffi.mjs", "reverse")
pub fn reverse(array: Uint8Array) -> Uint8Array

/// Copies the array and inserts the given number at the provided index.
///
@external(javascript, "./uint8_array.ffi.mjs", "with_")
pub fn with(array: Uint8Array, index: Int, value: Int) -> Uint8Array

/// Adds all the elements of an array separated by the specified separator
/// string.
///
@external(javascript, "./uint8_array.ffi.mjs", "join")
pub fn join(array: Uint8Array, separator: String) -> String

/// Determines whether all the members of an array satisfy the specified test.
///
@external(javascript, "./uint8_array.ffi.mjs", "every")
pub fn every(array: Uint8Array, predicate: fn(Int) -> Bool) -> Bool

/// Determines whether all the members of an array satisfy the specified test.
/// The predicate receives the value and its index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_every")
pub fn index_every(array: Uint8Array, predicate: fn(Int, Int) -> Bool) -> Bool

/// Determines whether the specified callback function returns true for any
/// element of an array.
///
@external(javascript, "./uint8_array.ffi.mjs", "some")
pub fn some(array: Uint8Array, predicate: fn(Int) -> Bool) -> Bool

/// Determines whether the specified callback function returns true for any
/// element of an array. The predicate receives the value and its index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_some")
pub fn index_some(array: Uint8Array, predicate: fn(Int, Int) -> Bool) -> Bool

/// Returns the value of the first element in the array where predicate is
/// true, and `None` otherwise.
///
@external(javascript, "./uint8_array.ffi.mjs", "find")
pub fn find(array: Uint8Array, predicate: fn(Int) -> Bool) -> Option(Int)

/// Returns the value of the first element in the array where predicate is
/// true, and `None` otherwise. The predicate receives the value and its index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_find")
pub fn index_find(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Option(Int)

/// Returns the index of the first element in the array where predicate is
/// true, and -1 otherwise.
///
@external(javascript, "./uint8_array.ffi.mjs", "find_index")
pub fn find_index(array: Uint8Array, predicate: fn(Int) -> Bool) -> Int

/// Returns the index of the first element in the array where predicate is
/// true, and -1 otherwise. The predicate receives the value and its index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_find_index")
pub fn index_find_index(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Int

/// Returns the value of the last element in the array where predicate is
/// true, and `None` otherwise.
///
@external(javascript, "./uint8_array.ffi.mjs", "find_last")
pub fn find_last(array: Uint8Array, predicate: fn(Int) -> Bool) -> Option(Int)

/// Returns the value of the last element in the array where predicate is
/// true, and `None` otherwise. The predicate receives the value and its index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_find_last")
pub fn index_find_last(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Option(Int)

/// Returns the index of the last element in the array where predicate is
/// true, and -1 otherwise.
///
@external(javascript, "./uint8_array.ffi.mjs", "find_last_index")
pub fn find_last_index(array: Uint8Array, predicate: fn(Int) -> Bool) -> Int

/// Returns the index of the last element in the array where predicate is
/// true, and -1 otherwise. The predicate receives the value and its index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_find_last_index")
pub fn index_find_last_index(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Int

/// Returns the elements of an array that meet the condition specified in a
/// callback function.
///
@external(javascript, "./uint8_array.ffi.mjs", "filter")
pub fn filter(array: Uint8Array, predicate: fn(Int) -> Bool) -> Uint8Array

/// Returns the elements of an array that meet the condition specified in a
/// callback function. The predicate receives the value and its index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_filter")
pub fn index_filter(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Uint8Array

/// Calls a defined callback function on each element of an array, and returns
/// an array that contains the results.
///
@external(javascript, "./uint8_array.ffi.mjs", "map")
pub fn map(array: Uint8Array, callback: fn(Int) -> Int) -> Uint8Array

/// Calls a defined callback function on each element of an array, and returns
/// an array that contains the results. The callback receives the value and its
/// index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_map")
pub fn index_map(array: Uint8Array, callback: fn(Int, Int) -> Int) -> Uint8Array

/// Performs the specified action for each element in an array.
///
@external(javascript, "./uint8_array.ffi.mjs", "for_each")
pub fn for_each(array: Uint8Array, callback: fn(Int) -> Nil) -> Nil

/// Performs the specified action for each element in an array. The callback
/// receives the value and its index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_for_each")
pub fn index_for_each(array: Uint8Array, callback: fn(Int, Int) -> Nil) -> Nil

/// Sorts an array.
///
@external(javascript, "./uint8_array.ffi.mjs", "sort")
pub fn sort(array: Uint8Array, compare: fn(Int, Int) -> Order) -> Uint8Array

/// Copies and sorts the array.
///
@external(javascript, "./uint8_array.ffi.mjs", "to_sorted")
pub fn to_sorted(
  array: Uint8Array,
  compare: fn(Int, Int) -> Order,
) -> Uint8Array

/// Copies the array and returns the copy with the elements in reverse order.
///
@external(javascript, "./uint8_array.ffi.mjs", "to_reversed")
pub fn to_reversed(array: Uint8Array) -> Uint8Array

/// Calls the specified callback function for all the elements in an array. The
/// return value of the callback function is the accumulated result, and is
/// provided as an argument in the next call to the callback function.
///
@external(javascript, "./uint8_array.ffi.mjs", "reduce")
pub fn reduce(array: Uint8Array, initial: a, callback: fn(a, Int) -> a) -> a

/// Calls the specified callback function for all the elements in an array, in
/// descending order. The return value of the callback function is the
/// accumulated result, and is provided as an argument in the next call to the
/// callback function.
///
@external(javascript, "./uint8_array.ffi.mjs", "reduce_right")
pub fn reduce_right(
  array: Uint8Array,
  initial: a,
  callback: fn(a, Int) -> a,
) -> a

/// Calls the specified callback function for all the elements in an array. The
/// callback receives the accumulator, value, and index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_reduce")
pub fn index_reduce(
  array: Uint8Array,
  initial: a,
  callback: fn(a, Int, Int) -> a,
) -> a

/// Calls the specified callback function for all the elements in an array, in
/// descending order. The callback receives the accumulator, value, and index.
///
@external(javascript, "./uint8_array.ffi.mjs", "index_reduce_right")
pub fn index_reduce_right(
  array: Uint8Array,
  initial: a,
  callback: fn(a, Int, Int) -> a,
) -> a

/// Converts the array to a `List(Int)`.
///
@external(javascript, "./uint8_array.ffi.mjs", "to_list")
pub fn to_list(array: Uint8Array) -> List(Int)

/// Converts the `Uint8Array` to a base64-encoded string.
///
@external(javascript, "./uint8_array.ffi.mjs", "to_base64")
pub fn to_base64(array: Uint8Array) -> String

/// Converts the `Uint8Array` to a base16-encoded string.
///
@external(javascript, "./uint8_array.ffi.mjs", "to_hex")
pub fn to_hex(array: Uint8Array) -> String

/// Sets the `Uint8Array` from a base64-encoded string, returning the number
/// of bytes read and written.
///
@external(javascript, "./uint8_array.ffi.mjs", "set_from_base64")
pub fn set_from_base64(array: Uint8Array, string: String) -> #(Int, Int)

/// Sets the `Uint8Array` from a base16-encoded string, returning the number
/// of bytes read and written.
///
@external(javascript, "./uint8_array.ffi.mjs", "set_from_hex")
pub fn set_from_hex(array: Uint8Array, string: String) -> #(Int, Int)
