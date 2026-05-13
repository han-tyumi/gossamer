import gleam/bit_array
import gleam/javascript/promise
import gleam/string
import gleeunit/should
import gossamer/blob
import gossamer/buffer/array_buffer

pub fn blob_from_string_test() {
  let b = blob.from_string("hello", content_type: "")
  should.equal(blob.size(b), 5)
  should.equal(blob.mime_type(b), "")
}

pub fn blob_from_string_with_type_test() {
  let b = blob.from_string("hello", content_type: "text/plain")
  should.equal(blob.size(b), 5)
  // Bun may append charset info (e.g., "text/plain;charset=utf-8").
  should.be_true(string.starts_with(blob.mime_type(b), "text/plain"))
}

pub fn blob_from_bytes_test() {
  let b = blob.from_bytes(<<1, 2, 3>>, content_type: "")
  should.equal(blob.size(b), 3)
}

pub fn blob_text_test() {
  let b = blob.from_string("hello world", content_type: "")
  use text <- promise.await(blob.text(b))
  should.equal(text, Ok("hello world"))
  promise.resolve(Nil)
}

pub fn blob_array_buffer_test() {
  let b = blob.from_string("hi", content_type: "")
  use result <- promise.await(blob.array_buffer(b))
  let assert Ok(buffer) = result
  should.equal(array_buffer.byte_length(buffer), 2)
  promise.resolve(Nil)
}

pub fn blob_bytes_test() {
  let b = blob.from_bytes(<<10, 20, 30>>, content_type: "")
  use result <- promise.await(blob.bytes(b))
  let assert Ok(bytes) = result
  should.equal(bit_array.byte_size(bytes), 3)
  promise.resolve(Nil)
}

pub fn blob_slice_test() {
  let b = blob.from_string("hello world", content_type: "")
  let sliced = blob.slice(b, 0, 5, content_type: "")
  use text <- promise.await(blob.text(sliced))
  should.equal(text, Ok("hello"))
  promise.resolve(Nil)
}

pub fn blob_empty_test() {
  let b = blob.new()
  should.equal(blob.size(b), 0)
}

pub fn blob_from_bytes_with_type_test() {
  let b =
    blob.from_bytes(
      <<72, 101, 108, 108, 111>>,
      content_type: "application/octet-stream",
    )
  should.equal(blob.size(b), 5)
  should.equal(blob.mime_type(b), "application/octet-stream")
}

pub fn blob_slice_with_type_test() {
  let b = blob.from_string("hello world", content_type: "")
  let sliced = blob.slice(b, 0, 5, content_type: "text/plain")
  should.equal(blob.size(sliced), 5)
  should.be_true(string.starts_with(blob.mime_type(sliced), "text/plain"))
  use text <- promise.await(blob.text(sliced))
  should.equal(text, Ok("hello"))
  promise.resolve(Nil)
}

pub fn blob_stream_test() {
  let b = blob.from_string("stream me", content_type: "")
  let _stream = blob.stream(b)
}

pub fn blob_from_unaligned_bytes_test() {
  let b = blob.from_bytes(<<1:1>>, content_type: "")
  should.equal(blob.size(b), 1)
}

pub fn blob_to_object_url_test() {
  blob.from_string("hello", content_type: "")
  |> blob.to_object_url
  |> string.starts_with("blob:")
  |> should.be_true
}

pub fn blob_revoke_object_url_test() {
  blob.from_string("hello", content_type: "")
  |> blob.to_object_url
  |> blob.revoke_object_url
}
