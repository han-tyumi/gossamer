import gleeunit/should
import gossamer/blob
import gossamer/file
import gossamer/form_data

pub fn form_data_append_get_test() {
  let fd =
    form_data.new()
    |> form_data.append("name", "value")
  should.equal(form_data.get(fd, "name"), Ok("value"))
  should.equal(form_data.get(fd, "missing"), Error(Nil))
}

pub fn form_data_has_delete_test() {
  let fd =
    form_data.new()
    |> form_data.append("key", "val")
  should.be_true(form_data.has(fd, "key"))
  let fd = form_data.delete(fd, "key")
  should.be_false(form_data.has(fd, "key"))
}

pub fn form_data_set_test() {
  let fd =
    form_data.new()
    |> form_data.append("key", "first")
    |> form_data.append("key", "second")
  should.equal(form_data.get_all(fd, "key"), ["first", "second"])

  let fd = form_data.set(fd, "key", "replaced")
  should.equal(form_data.get_all(fd, "key"), ["replaced"])
}

pub fn form_data_keys_test() {
  let fd =
    form_data.new()
    |> form_data.append("a", "1")
    |> form_data.append("b", "2")
  should.equal(form_data.keys(fd), ["a", "b"])
}

pub fn form_data_blob_test() {
  let b = blob.from_string("file content")
  let fd =
    form_data.new()
    |> form_data.append_blob_with_filename("upload", b, "test.txt")
  case form_data.get_file(fd, "upload") {
    Ok(f) -> should.equal(file.name(f), "test.txt")
    Error(Nil) -> should.fail()
  }
}

pub fn form_data_get_all_files_test() {
  let b1 = blob.from_string("file 1")
  let b2 = blob.from_string("file 2")
  let fd =
    form_data.new()
    |> form_data.append_blob_with_filename("files", b1, "a.txt")
    |> form_data.append_blob_with_filename("files", b2, "b.txt")
  let files = form_data.get_all_files(fd, "files")
  case files {
    [first, second] -> {
      should.equal(file.name(first), "a.txt")
      should.equal(file.name(second), "b.txt")
    }
    _ -> should.fail()
  }
}
