import gleam/option.{None, Some}
import gossamer/blob
import gossamer/buffer/array_buffer
import gossamer/buffer/uint8_array
import gossamer/form_data
import gossamer/headers
import gossamer/http_status
import gossamer/iterator
import gossamer/promise
import gossamer/readable_stream
import gossamer/readable_stream/default_controller
import gossamer/response
import gossamer/response_type
import gossamer/url
import gossamer/url_search_params

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

pub fn response_from_string_test() {
  let resp = response.from_string("hello")
  response.status(resp) |> should.equal(http_status.Ok)
  response.is_ok(resp) |> should.be_true()
}

pub fn response_from_string_with_test() {
  let assert Ok(resp) =
    response.from_string_with("not found", [
      response.Status(http_status.NotFound),
      response.StatusText("Not Found"),
    ])
  response.status(resp) |> should.equal(http_status.NotFound)
  response.status_text(resp) |> should.equal("Not Found")
  response.is_ok(resp) |> should.be_false()
}

pub fn response_text_test() {
  let resp = response.from_string("hello world")
  use text <- promise.then(response.text(resp))
  should.equal(text, Ok("hello world"))
}

pub fn response_error_test() {
  let resp = response.error()
  response.type_(resp) |> should.equal(response_type.Error)
}

pub fn response_redirect_test() {
  let assert Ok(resp) =
    response.redirect_with_status(
      "https://example.org",
      http_status.MovedPermanently,
    )
  response.status(resp) |> should.equal(http_status.MovedPermanently)
}

pub fn response_redirect_url_test() {
  let assert Ok(u) = url.new("https://example.org")
  let resp = response.redirect_url(u)
  response.status(resp) |> should.equal(http_status.Found)
}

pub fn response_redirect_url_with_status_test() {
  let assert Ok(u) = url.new("https://example.org")
  let assert Ok(resp) =
    response.redirect_url_with_status(u, http_status.MovedPermanently)
  response.status(resp) |> should.equal(http_status.MovedPermanently)
}

pub fn response_redirect_parity_test() {
  // String-input and URL-input redirect variants produce responses with
  // the same observable location header and status.
  let location = "https://example.org/new"
  let assert Ok(u) = url.new(location)

  let assert Ok(from_string) = response.redirect(location)
  let from_url = response.redirect_url(u)

  let hdr = fn(r) {
    let assert Ok(Some(h)) = headers.get(response.headers(r), "location")
    h
  }
  hdr(from_string) |> should.equal(hdr(from_url))
  response.status(from_string) |> should.equal(response.status(from_url))
}

pub fn response_clone_test() {
  let resp = response.from_string("hello")
  let assert Ok(cloned) = response.clone(resp)
  use text <- promise.then(response.text(cloned))
  should.equal(text, Ok("hello"))
}

pub fn response_get_not_found_test() {
  let assert Ok(resp) =
    response.from_string_with("", [response.Status(http_status.NotFound)])
  response.is_ok(resp) |> should.be_false()
  response.status(resp) |> should.equal(http_status.NotFound)
}

pub fn response_blob_test() {
  let resp = response.from_string("blob response")
  use result <- promise.then(response.blob(resp))
  let assert Ok(b) = result
  should.equal(blob.size(b), 13)
  promise.resolve(Nil)
}

pub fn response_form_data_test() {
  let assert Ok(hdrs) =
    headers.from_pairs([
      #("content-type", "application/x-www-form-urlencoded"),
    ])
  let assert Ok(resp) =
    response.from_string_with("key=value", [response.Headers(hdrs)])
  use result <- promise.then(response.form_data(resp))
  let assert Ok(_fd) = result
  promise.resolve(Nil)
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

pub fn response_from_json_test() {
  let assert Ok(resp) = response.from_json(42)
  response.status(resp) |> should.equal(http_status.Ok)
  use result <- promise.then(response.text(resp))
  should.equal(result, Ok("42"))
  promise.resolve(Nil)
}

pub fn response_is_body_used_test() {
  let resp = response.from_string("hello")
  response.is_body_used(resp) |> should.be_false
}

pub fn response_body_test() {
  let resp = response.from_string("hello")
  response.body(resp) |> should.be_ok
}

pub fn response_array_buffer_test() {
  let resp = response.from_string("hi")
  use result <- promise.then(response.array_buffer(resp))
  let assert Ok(buffer) = result
  array_buffer.byte_length(buffer) |> should.equal(2)
  promise.resolve(Nil)
}

pub fn response_bytes_test() {
  let resp = response.from_string("abc")
  use result <- promise.then(response.bytes(resp))
  let assert Ok(bytes) = result
  uint8_array.byte_length(bytes) |> should.equal(3)
  promise.resolve(Nil)
}

pub fn response_json_test() {
  let assert Ok(hdrs) =
    headers.from_pairs([#("content-type", "application/json")])
  let assert Ok(resp) =
    response.from_string_with("{\"a\":1}", [response.Headers(hdrs)])
  use result <- promise.then(response.json(resp))
  should.be_ok(result)
  promise.resolve(Nil)
}

pub fn response_is_redirected_test() {
  let resp = response.from_string("hello")
  response.is_redirected(resp) |> should.be_false
}

pub fn response_url_test() {
  let resp = response.from_string("hello")
  response.url(resp) |> should.equal("")
}

pub fn response_new_empty_test() {
  let resp = response.new()
  response.is_body_used(resp) |> should.be_false
}

pub fn response_from_bytes_test() {
  let bytes = uint8_array.from_list([104, 105])
  let resp = response.from_bytes(bytes)
  use result <- promise.then(response.text(resp))
  should.equal(result, Ok("hi"))
  promise.resolve(Nil)
}

pub fn response_from_bytes_with_test() {
  let bytes = uint8_array.from_list([104, 105])
  let assert Ok(resp) =
    response.from_bytes_with(bytes, [response.Status(http_status.Created)])
  response.status(resp) |> should.equal(http_status.Created)
}

pub fn response_from_blob_test() {
  let b = blob.from_string("hello")
  let resp = response.from_blob(b)
  use result <- promise.then(response.text(resp))
  should.equal(result, Ok("hello"))
  promise.resolve(Nil)
}

pub fn response_from_form_data_test() {
  let fd = form_data.new()
  let fd = form_data.append(fd, "key", "value")
  let resp = response.from_form_data(fd)
  response.status(resp) |> should.equal(http_status.Ok)
}

pub fn response_from_params_test() {
  let params = url_search_params.from_string("a=1&b=2")
  let resp = response.from_params(params)
  use result <- promise.then(response.text(resp))
  should.equal(result, Ok("a=1&b=2"))
  promise.resolve(Nil)
}

pub fn response_from_stream_test() {
  let bytes = uint8_array.from_list([104, 105])
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let assert Ok(_) = default_controller.enqueue(controller, bytes)
      let assert Ok(_) = default_controller.close(controller)
      Nil
    })
  let assert Ok(resp) = response.from_stream(stream)
  use result <- promise.then(response.text(resp))
  should.equal(result, Ok("hi"))
  promise.resolve(Nil)
}

pub fn response_from_json_with_test() {
  let assert Ok(resp) =
    response.from_json_with(42, [
      response.Status(http_status.Created),
    ])
  response.status(resp) |> should.equal(http_status.Created)
}
