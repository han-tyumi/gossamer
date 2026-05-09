import gleam/fetch/form_data
import gleeunit/should
import gossamer/blob
import gossamer/file
import gossamer/form_data_extra

pub fn append_file_test() {
  let f = file.from_blob(blob.from_string("data"), named: "test.txt")
  let fd = form_data.new() |> form_data_extra.append_file("upload", f)
  fd |> form_data.contains("upload") |> should.be_true
}

pub fn set_file_replaces_test() {
  let f = file.from_blob(blob.from_string("replaced"), named: "test.txt")
  let fd =
    form_data.new()
    |> form_data.append("upload", "first")
    |> form_data_extra.set_file("upload", f)
  fd |> form_data.contains("upload") |> should.be_true
  fd |> form_data.get("upload") |> should.equal([])
}
