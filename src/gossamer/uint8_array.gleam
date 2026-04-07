import gleam/order.{type Order}
import gossamer/array_buffer.{type ArrayBuffer}

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

@external(javascript, "./uint8_array.ffi.mjs", "from_base64")
pub fn from_base64(string: String) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "from_hex")
pub fn from_hex(string: String) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "buffer")
pub fn buffer(array: Uint8Array) -> ArrayBuffer

@external(javascript, "./uint8_array.ffi.mjs", "byte_length")
pub fn byte_length(array: Uint8Array) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "byte_offset")
pub fn byte_offset(array: Uint8Array) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "length")
pub fn length(array: Uint8Array) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "at")
pub fn at(array: Uint8Array, index: Int) -> Result(Int, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "includes")
pub fn includes(array: Uint8Array, value: Int) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "includes_from")
pub fn includes_from(array: Uint8Array, value: Int, from_index: Int) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "index_of")
pub fn index_of(array: Uint8Array, value: Int) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "index_of_from")
pub fn index_of_from(array: Uint8Array, value: Int, from_index: Int) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "last_index_of")
pub fn last_index_of(array: Uint8Array, value: Int) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "last_index_of_from")
pub fn last_index_of_from(array: Uint8Array, value: Int, from_index: Int) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "slice")
pub fn slice(array: Uint8Array) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "slice_from")
pub fn slice_from(array: Uint8Array, start: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "slice_range")
pub fn slice_range(array: Uint8Array, start: Int, end: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "subarray")
pub fn subarray(array: Uint8Array, begin: Int, end: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "set")
pub fn set(array: Uint8Array, values: Uint8Array) -> Nil

@external(javascript, "./uint8_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  array: Uint8Array,
  values: Uint8Array,
  offset: Int,
) -> Nil

@external(javascript, "./uint8_array.ffi.mjs", "copy_within")
pub fn copy_within(array: Uint8Array, target: Int, start: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "copy_within_range")
pub fn copy_within_range(
  array: Uint8Array,
  target: Int,
  start: Int,
  end: Int,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "fill")
pub fn fill(array: Uint8Array, value: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "fill_range")
pub fn fill_range(
  array: Uint8Array,
  value: Int,
  start: Int,
  end: Int,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "reverse")
pub fn reverse(array: Uint8Array) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "with_")
pub fn with(array: Uint8Array, index: Int, value: Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "join")
pub fn join(array: Uint8Array, separator: String) -> String

@external(javascript, "./uint8_array.ffi.mjs", "every")
pub fn every(array: Uint8Array, predicate: fn(Int) -> Bool) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "index_every")
pub fn index_every(array: Uint8Array, predicate: fn(Int, Int) -> Bool) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "some")
pub fn some(array: Uint8Array, predicate: fn(Int) -> Bool) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "index_some")
pub fn index_some(array: Uint8Array, predicate: fn(Int, Int) -> Bool) -> Bool

@external(javascript, "./uint8_array.ffi.mjs", "find")
pub fn find(array: Uint8Array, predicate: fn(Int) -> Bool) -> Result(Int, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "index_find")
pub fn index_find(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Result(Int, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "find_index")
pub fn find_index(array: Uint8Array, predicate: fn(Int) -> Bool) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "index_find_index")
pub fn index_find_index(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "find_last")
pub fn find_last(
  array: Uint8Array,
  predicate: fn(Int) -> Bool,
) -> Result(Int, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "index_find_last")
pub fn index_find_last(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Result(Int, Nil)

@external(javascript, "./uint8_array.ffi.mjs", "find_last_index")
pub fn find_last_index(array: Uint8Array, predicate: fn(Int) -> Bool) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "index_find_last_index")
pub fn index_find_last_index(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Int

@external(javascript, "./uint8_array.ffi.mjs", "filter")
pub fn filter(array: Uint8Array, predicate: fn(Int) -> Bool) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "index_filter")
pub fn index_filter(
  array: Uint8Array,
  predicate: fn(Int, Int) -> Bool,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "map")
pub fn map(array: Uint8Array, callback: fn(Int) -> Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "index_map")
pub fn index_map(array: Uint8Array, callback: fn(Int, Int) -> Int) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "for_each")
pub fn for_each(array: Uint8Array, callback: fn(Int) -> Nil) -> Nil

@external(javascript, "./uint8_array.ffi.mjs", "index_for_each")
pub fn index_for_each(array: Uint8Array, callback: fn(Int, Int) -> Nil) -> Nil

@external(javascript, "./uint8_array.ffi.mjs", "sort")
pub fn sort(array: Uint8Array, compare: fn(Int, Int) -> Order) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "to_sorted")
pub fn to_sorted(
  array: Uint8Array,
  compare: fn(Int, Int) -> Order,
) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "to_reversed")
pub fn to_reversed(array: Uint8Array) -> Uint8Array

@external(javascript, "./uint8_array.ffi.mjs", "reduce")
pub fn reduce(array: Uint8Array, initial: a, callback: fn(a, Int) -> a) -> a

@external(javascript, "./uint8_array.ffi.mjs", "reduce_right")
pub fn reduce_right(
  array: Uint8Array,
  initial: a,
  callback: fn(a, Int) -> a,
) -> a

@external(javascript, "./uint8_array.ffi.mjs", "index_reduce")
pub fn index_reduce(
  array: Uint8Array,
  initial: a,
  callback: fn(a, Int, Int) -> a,
) -> a

@external(javascript, "./uint8_array.ffi.mjs", "index_reduce_right")
pub fn index_reduce_right(
  array: Uint8Array,
  initial: a,
  callback: fn(a, Int, Int) -> a,
) -> a

@external(javascript, "./uint8_array.ffi.mjs", "to_list")
pub fn to_list(array: Uint8Array) -> List(Int)

@external(javascript, "./uint8_array.ffi.mjs", "to_base64")
pub fn to_base64(array: Uint8Array) -> String

@external(javascript, "./uint8_array.ffi.mjs", "to_hex")
pub fn to_hex(array: Uint8Array) -> String

@external(javascript, "./uint8_array.ffi.mjs", "set_from_base64")
pub fn set_from_base64(array: Uint8Array, string: String) -> #(Int, Int)

@external(javascript, "./uint8_array.ffi.mjs", "set_from_hex")
pub fn set_from_hex(array: Uint8Array, string: String) -> #(Int, Int)
