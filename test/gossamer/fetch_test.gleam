import gleam/option.{None, Some}
import gossamer/headers
import gossamer/iterator

import gleeunit/should

pub fn headers_new_test() {
  let hdrs = headers.new()
  headers.has(hdrs, "content-type") |> should.equal(Ok(False))
}

pub fn headers_from_pairs_test() {
  let assert Ok(hdrs) = headers.from_pairs([#("content-type", "text/plain")])
  headers.get(hdrs, "content-type") |> should.equal(Ok(Some("text/plain")))
}

pub fn headers_get_none_test() {
  let hdrs = headers.new()
  headers.get(hdrs, "x-missing") |> should.equal(Ok(None))
}

pub fn headers_get_invalid_name_test() {
  let hdrs = headers.new()
  // Header names must be valid ByteString tokens; a space is not.
  headers.get(hdrs, "bad name") |> should.be_error
}

pub fn headers_append_test() {
  let hdrs = headers.new()
  let assert Ok(_) = headers.append(hdrs, "x-custom", "value1")
  let assert Ok(_) = headers.append(hdrs, "x-custom", "value2")
  headers.get(hdrs, "x-custom")
  |> should.equal(Ok(Some("value1, value2")))
}

pub fn headers_set_test() {
  let hdrs = headers.new()
  let assert Ok(_) = headers.set(hdrs, "x-custom", "value1")
  let assert Ok(_) = headers.set(hdrs, "x-custom", "value2")
  headers.get(hdrs, "x-custom") |> should.equal(Ok(Some("value2")))
}

pub fn headers_delete_test() {
  let assert Ok(hdrs) = headers.from_pairs([#("x-custom", "value")])
  let assert Ok(_) = headers.delete(hdrs, "x-custom")
  headers.has(hdrs, "x-custom") |> should.equal(Ok(False))
}

pub fn headers_keys_test() {
  let assert Ok(hdrs) = headers.from_pairs([#("b", "2"), #("a", "1")])
  headers.keys(hdrs) |> iterator.to_list |> should.equal(["a", "b"])
}

pub fn headers_entries_test() {
  let assert Ok(hdrs) = headers.from_pairs([#("a", "1")])
  headers.entries(hdrs) |> iterator.to_list |> should.equal([#("a", "1")])
}

pub fn headers_values_test() {
  let assert Ok(hdrs) = headers.from_pairs([#("a", "1"), #("b", "2")])
  headers.values(hdrs) |> iterator.to_list |> should.equal(["1", "2"])
}

pub fn headers_for_each_test() {
  let assert Ok(hdrs) = headers.from_pairs([#("x", "1")])
  headers.for_each(hdrs, fn(_name, _value) { Nil })
}

pub fn headers_get_set_cookie_test() {
  let hdrs = headers.new()
  headers.get_set_cookie(hdrs) |> should.equal([])
}
