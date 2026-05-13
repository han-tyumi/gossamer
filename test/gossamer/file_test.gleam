import gleam/bit_array
import gleam/javascript/promise
import gleam/order
import gleam/string
import gleam/time/timestamp
import gleeunit/should
import gossamer/blob
import gossamer/buffer/array_buffer
import gossamer/file

pub fn file_from_strings_test() {
  let f = file.from_strings(["hello", " ", "world"], "test.txt")
  should.equal(f.name, "test.txt")

  let b = f.blob
  use text <- promise.await(blob.text(b))
  should.equal(text, Ok("hello world"))
  promise.resolve(Nil)
}

pub fn file_from_blob_test() {
  let b = blob.from_string("blob content", content_type: "")
  let f = file.from_blob(b, "from_blob.txt")
  should.equal(f.name, "from_blob.txt")

  let converted = f.blob
  use text <- promise.await(blob.text(converted))
  should.equal(text, Ok("blob content"))
  promise.resolve(Nil)
}

pub fn file_last_modified_test() {
  let f = file.from_strings(["data"], "modified.txt")
  timestamp.compare(f.last_modified, timestamp.from_unix_seconds(0))
  |> should.equal(order.Gt)
}

pub fn file_set_mime_type_from_strings_test() {
  let f =
    file.from_strings(["hello"], "typed.txt")
    |> file.set_mime_type("text/plain")
  f.name |> should.equal("typed.txt")
  should.be_true(string.starts_with(f.mime_type, "text/plain"))
}

pub fn file_set_mime_type_from_blob_test() {
  let b = blob.from_string("blob data", content_type: "")
  let f = file.from_blob(b, "blob.txt") |> file.set_mime_type("text/plain")
  f.name |> should.equal("blob.txt")
  should.be_true(string.starts_with(f.mime_type, "text/plain"))
}

pub fn file_set_last_modified_test() {
  let epoch = timestamp.from_unix_seconds(0)
  let f =
    file.from_strings(["data"], "modified.txt")
    |> file.set_last_modified(epoch)
  f.last_modified |> should.equal(epoch)
}

pub fn file_size_test() {
  let f = file.from_strings(["hello"], "size.txt")
  file.size(f) |> should.equal(5)
}

pub fn file_type_test() {
  let f = file.from_strings(["data"], "no-type.txt")
  f.mime_type |> should.equal("")
}

pub fn file_array_buffer_test() {
  let f = file.from_strings(["hi"], "buf.txt")
  use result <- promise.await(file.array_buffer(f))
  let assert Ok(buffer) = result
  array_buffer.byte_length(buffer) |> should.equal(2)
  promise.resolve(Nil)
}

pub fn file_bytes_test() {
  let f = file.from_strings(["abc"], "bytes.txt")
  use result <- promise.await(file.bytes(f))
  let assert Ok(bytes) = result
  bit_array.byte_size(bytes) |> should.equal(3)
  promise.resolve(Nil)
}

pub fn file_slice_test() {
  let f = file.from_strings(["hello world"], "slice.txt")
  let sliced = file.slice(f, 0, 5, content_type: "")
  use text <- promise.await(blob.text(sliced))
  should.equal(text, Ok("hello"))
  promise.resolve(Nil)
}

pub fn file_slice_with_type_test() {
  let f = file.from_strings(["hello world"], "slice-type.txt")
  let sliced = file.slice(f, 0, 5, content_type: "text/plain")
  should.be_true(string.starts_with(blob.mime_type(sliced), "text/plain"))
}

pub fn file_stream_test() {
  let f = file.from_strings(["stream data"], "stream.txt")
  let _stream = file.stream(f)
}

pub fn file_text_test() {
  let f = file.from_strings(["file text content"], "text.txt")
  use result <- promise.await(file.text(f))
  should.equal(result, Ok("file text content"))
  promise.resolve(Nil)
}
