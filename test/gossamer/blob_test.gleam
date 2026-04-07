import gossamer/array_buffer
import gossamer/blob
import gossamer/promise
import gossamer/uint8_array
import gleam/string
import gleeunit/should

pub fn blob_from_string_test() {
  let b = blob.from_string("hello")
  should.equal(blob.size(b), 5)
  should.equal(blob.type_(b), "")
}

pub fn blob_from_string_with_type_test() {
  let b = blob.from_string_with_type("hello", "text/plain")
  should.equal(blob.size(b), 5)
  should.be_true(string.starts_with(blob.type_(b), "text/plain"))
}

pub fn blob_from_bytes_test() {
  let b = blob.from_bytes(uint8_array.from_list([1, 2, 3]))
  should.equal(blob.size(b), 3)
}

pub fn blob_text_test() {
  let b = blob.from_string("hello world")
  use text <- promise.then(blob.text(b))
  should.equal(text, "hello world")
  promise.resolve(Nil)
}

pub fn blob_array_buffer_test() {
  let b = blob.from_string("hi")
  use buffer <- promise.then(blob.array_buffer(b))
  should.equal(array_buffer.byte_length(buffer), 2)
  promise.resolve(Nil)
}

pub fn blob_bytes_test() {
  let b = blob.from_bytes(uint8_array.from_list([10, 20, 30]))
  use bytes <- promise.then(blob.bytes(b))
  should.equal(uint8_array.byte_length(bytes), 3)
  promise.resolve(Nil)
}

pub fn blob_slice_test() {
  let b = blob.from_string("hello world")
  let sliced = blob.slice(b, 0, 5)
  use text <- promise.then(blob.text(sliced))
  should.equal(text, "hello")
  promise.resolve(Nil)
}

pub fn blob_empty_test() {
  let b = blob.new()
  should.equal(blob.size(b), 0)
}
