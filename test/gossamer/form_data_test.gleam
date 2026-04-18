import gleeunit/should
import gossamer/blob
import gossamer/file
import gossamer/form_data
import gossamer/iterator

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
  form_data.keys(fd) |> iterator.to_list |> should.equal(["a", "b"])
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

pub fn form_data_append_blob_test() {
  let b = blob.from_string("blob data")
  let fd =
    form_data.new()
    |> form_data.append_blob("upload", b)
  form_data.has(fd, "upload") |> should.be_true
}

pub fn form_data_set_blob_test() {
  let b = blob.from_string("blob data")
  let fd =
    form_data.new()
    |> form_data.set_blob("field", b)
  form_data.has(fd, "field") |> should.be_true
}

pub fn form_data_set_blob_with_filename_test() {
  let b = blob.from_string("named blob")
  let fd =
    form_data.new()
    |> form_data.set_blob_with_filename("upload", b, "named.txt")
  let assert Ok(f) = form_data.get_file(fd, "upload")
  file.name(f) |> should.equal("named.txt")
}

pub fn form_data_get_all_test() {
  let fd =
    form_data.new()
    |> form_data.append("key", "first")
    |> form_data.append("key", "second")
  form_data.get_all(fd, "key") |> should.equal(["first", "second"])
}

pub fn form_data_values_test() {
  let fd =
    form_data.new()
    |> form_data.append("a", "1")
    |> form_data.append("b", "2")
  form_data.values(fd)
  |> iterator.to_list
  |> should.equal([form_data.Text("1"), form_data.Text("2")])
}

pub fn form_data_entries_test() {
  let fd =
    form_data.new()
    |> form_data.append("a", "1")
    |> form_data.append("b", "2")
  form_data.entries(fd)
  |> iterator.to_list
  |> should.equal([
    #("a", form_data.Text("1")),
    #("b", form_data.Text("2")),
  ])
}

pub fn form_data_for_each_test() {
  let fd =
    form_data.new()
    |> form_data.append("x", "10")
  form_data.for_each(fd, fn(_name, _value) { Nil })
}
