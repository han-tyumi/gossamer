import gleeunit/should
import gossamer/big_int
import gossamer/bigint64_array
import gossamer/int32_array
import gossamer/int_typed_array
import gossamer/typed_array
import gossamer/uint8_array

pub fn construct_uint8_test() {
  let arr = uint8_array.from_list([1, 2, 3])
  let _: int_typed_array.IntTypedArray = int_typed_array.Uint8(arr)
}

pub fn construct_int32_test() {
  let arr = int32_array.from_list([100, 200, 300])
  let _: int_typed_array.IntTypedArray = int_typed_array.Int32(arr)
}

pub fn to_typed_array_widens_uint8_test() {
  let arr = uint8_array.from_list([7, 8, 9])
  let int_typed = int_typed_array.Uint8(arr)
  let widened = int_typed_array.to_typed_array(int_typed)

  // Pattern match on the wider TypedArray to recover.
  let recovered_length = case widened {
    typed_array.Uint8(_) -> typed_array.length(widened)
    _ -> 0
  }
  recovered_length |> should.equal(3)
}

pub fn to_typed_array_widens_int32_test() {
  let arr = int32_array.from_list([10, 20, 30, 40])
  let widened = int_typed_array.to_typed_array(int_typed_array.Int32(arr))

  let recovered_length = case widened {
    typed_array.Int32(_) -> typed_array.length(widened)
    _ -> 0
  }
  recovered_length |> should.equal(4)
}

pub fn to_typed_array_widens_bigint64_test() {
  let arr = bigint64_array.from_list([big_int.from_int(1), big_int.from_int(2)])
  let widened = int_typed_array.to_typed_array(int_typed_array.BigInt64(arr))

  let recovered_length = case widened {
    typed_array.BigInt64(_) -> typed_array.length(widened)
    _ -> 0
  }
  recovered_length |> should.equal(2)
}
