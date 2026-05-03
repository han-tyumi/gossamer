import gleam/string
import gleeunit/should
import gossamer/array_buffer
import gossamer/blob
import gossamer/promise
import gossamer/typed_array
import gossamer/uint8_array

pub fn blob_from_string_test() {
  let b = blob.from_string("hello")
  should.equal(blob.size(b), 5)
  should.equal(blob.type_(b), "")
}

pub fn blob_from_string_with_type_test() {
  let b = blob.from_string_with_type("hello", "text/plain")
  should.equal(blob.size(b), 5)
  // Bun may append charset info (e.g., "text/plain;charset=utf-8").
  should.be_true(string.starts_with(blob.type_(b), "text/plain"))
}

pub fn blob_from_typed_array_test() {
  let b =
    blob.from_typed_array(typed_array.Uint8(uint8_array.from_list([1, 2, 3])))
  should.equal(blob.size(b), 3)
}

pub fn blob_text_test() {
  let b = blob.from_string("hello world")
  use text <- promise.then(blob.text(b))
  should.equal(text, Ok("hello world"))
  promise.resolve(Nil)
}

pub fn blob_array_buffer_test() {
  let b = blob.from_string("hi")
  use result <- promise.then(blob.array_buffer(b))
  let assert Ok(buffer) = result
  should.equal(array_buffer.byte_length(buffer), 2)
  promise.resolve(Nil)
}

pub fn blob_bytes_test() {
  let b =
    blob.from_typed_array(
      typed_array.Uint8(uint8_array.from_list([10, 20, 30])),
    )
  use result <- promise.then(blob.bytes(b))
  let assert Ok(bytes) = result
  should.equal(uint8_array.byte_length(bytes), 3)
  promise.resolve(Nil)
}

pub fn blob_slice_test() {
  let b = blob.from_string("hello world")
  let sliced = blob.slice(b, 0, 5)
  use text <- promise.then(blob.text(sliced))
  should.equal(text, Ok("hello"))
  promise.resolve(Nil)
}

pub fn blob_empty_test() {
  let b = blob.new()
  should.equal(blob.size(b), 0)
}

pub fn blob_from_typed_array_with_type_test() {
  let b =
    blob.from_typed_array_with_type(
      typed_array.Uint8(uint8_array.from_list([72, 101, 108, 108, 111])),
      "application/octet-stream",
    )
  should.equal(blob.size(b), 5)
  should.equal(blob.type_(b), "application/octet-stream")
}

pub fn blob_slice_with_type_test() {
  let b = blob.from_string("hello world")
  let sliced = blob.slice_with_type(b, 0, 5, "text/plain")
  should.equal(blob.size(sliced), 5)
  should.be_true(string.starts_with(blob.type_(sliced), "text/plain"))
  use text <- promise.then(blob.text(sliced))
  should.equal(text, Ok("hello"))
  promise.resolve(Nil)
}

pub fn blob_stream_test() {
  let b = blob.from_string("stream me")
  let _stream = blob.stream(b)
}
