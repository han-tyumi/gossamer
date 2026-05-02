import gleam/string
import gleeunit/should
import gossamer/array_buffer
import gossamer/blob
import gossamer/promise
import gossamer/uint8_array

pub fn blob_from_string_test() {
  let b = blob.from_string("hello")
  b.size |> should.equal(5)
  b.type_ |> should.equal("")
}

pub fn blob_from_string_with_type_test() {
  let b = blob.from_string_with_type("hello", "text/plain")
  b.size |> should.equal(5)
  // Bun may append charset info (e.g., "text/plain;charset=utf-8").
  should.be_true(string.starts_with(b.type_, "text/plain"))
}

pub fn blob_from_bytes_test() {
  let b = blob.from_bytes(uint8_array.from_list([1, 2, 3]))
  b.size |> should.equal(3)
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
  let b = blob.from_bytes(uint8_array.from_list([10, 20, 30]))
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
  b.size |> should.equal(0)
}

pub fn blob_from_bytes_with_type_test() {
  let b =
    blob.from_bytes_with_type(
      uint8_array.from_list([72, 101, 108, 108, 111]),
      "application/octet-stream",
    )
  b.size |> should.equal(5)
  b.type_ |> should.equal("application/octet-stream")
}

pub fn blob_slice_with_type_test() {
  let b = blob.from_string("hello world")
  let sliced = blob.slice_with_type(b, 0, 5, "text/plain")
  sliced.size |> should.equal(5)
  should.be_true(string.starts_with(sliced.type_, "text/plain"))
  use text <- promise.then(blob.text(sliced))
  should.equal(text, Ok("hello"))
  promise.resolve(Nil)
}

pub fn blob_stream_test() {
  let b = blob.from_string("stream me")
  let _stream = blob.stream(b)
}
