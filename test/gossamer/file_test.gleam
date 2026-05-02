import gleam/string
import gleeunit/should
import gossamer/array_buffer
import gossamer/blob
import gossamer/file
import gossamer/promise
import gossamer/uint8_array

pub fn file_from_strings_test() {
  let f = file.from_strings(["hello", " ", "world"], "test.txt")
  f.name |> should.equal("test.txt")

  let b = file.to_blob(f)
  use text <- promise.then(blob.text(b))
  should.equal(text, Ok("hello world"))
  promise.resolve(Nil)
}

pub fn file_from_blob_test() {
  let b = blob.from_string("blob content")
  let f = file.from_blob(b, "from_blob.txt")
  f.name |> should.equal("from_blob.txt")

  let converted = file.to_blob(f)
  use text <- promise.then(blob.text(converted))
  should.equal(text, Ok("blob content"))
  promise.resolve(Nil)
}

pub fn file_last_modified_test() {
  let f = file.from_strings(["data"], "modified.txt")
  should.be_true(f.last_modified > 0)
}

pub fn file_from_strings_with_test() {
  let f =
    file.from_strings_with(["hello"], "typed.txt", [
      file.Type("text/plain"),
    ])
  f.name |> should.equal("typed.txt")
  should.be_true(string.starts_with(f.type_, "text/plain"))
}

pub fn file_from_blob_with_test() {
  let b = blob.from_string("blob data")
  let f = file.from_blob_with(b, "blob.txt", [file.Type("text/plain")])
  f.name |> should.equal("blob.txt")
  should.be_true(string.starts_with(f.type_, "text/plain"))
}

pub fn file_size_test() {
  let f = file.from_strings(["hello"], "size.txt")
  f.size |> should.equal(5)
}

pub fn file_type_test() {
  let f = file.from_strings(["data"], "no-type.txt")
  f.type_ |> should.equal("")
}

pub fn file_array_buffer_test() {
  let f = file.from_strings(["hi"], "buf.txt")
  use result <- promise.then(file.array_buffer(f))
  let assert Ok(buffer) = result
  array_buffer.byte_length(buffer) |> should.equal(2)
  promise.resolve(Nil)
}

pub fn file_bytes_test() {
  let f = file.from_strings(["abc"], "bytes.txt")
  use result <- promise.then(file.bytes(f))
  let assert Ok(bytes) = result
  uint8_array.byte_length(bytes) |> should.equal(3)
  promise.resolve(Nil)
}

pub fn file_slice_test() {
  let f = file.from_strings(["hello world"], "slice.txt")
  let sliced = file.slice(f, 0, 5)
  use text <- promise.then(blob.text(sliced))
  should.equal(text, Ok("hello"))
  promise.resolve(Nil)
}

pub fn file_slice_with_type_test() {
  let f = file.from_strings(["hello world"], "slice-type.txt")
  let sliced = file.slice_with_type(f, 0, 5, "text/plain")
  should.be_true(string.starts_with(sliced.type_, "text/plain"))
}

pub fn file_stream_test() {
  let f = file.from_strings(["stream data"], "stream.txt")
  let _stream = file.stream(f)
}

pub fn file_text_test() {
  let f = file.from_strings(["file text content"], "text.txt")
  use result <- promise.then(file.text(f))
  should.equal(result, Ok("file text content"))
  promise.resolve(Nil)
}
