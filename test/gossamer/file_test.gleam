import gleeunit/should
import gossamer/blob
import gossamer/file
import gossamer/promise

pub fn file_from_strings_test() {
  let f = file.from_strings(["hello", " ", "world"], "test.txt")
  should.equal(file.name(f), "test.txt")

  let b = file.to_blob(f)
  use text <- promise.then(blob.text(b))
  should.equal(text, Ok("hello world"))
  promise.resolve(Nil)
}

pub fn file_from_blob_test() {
  let b = blob.from_string("blob content")
  let f = file.from_blob(b, "from_blob.txt")
  should.equal(file.name(f), "from_blob.txt")

  let converted = file.to_blob(f)
  use text <- promise.then(blob.text(converted))
  should.equal(text, Ok("blob content"))
  promise.resolve(Nil)
}

pub fn file_last_modified_test() {
  let f = file.from_strings(["data"], "modified.txt")
  should.be_true(file.last_modified(f) > 0)
}
