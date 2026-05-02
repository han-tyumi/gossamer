import gossamer/array_buffer
import gossamer/blob
import gossamer/headers
import gossamer/http_method
import gossamer/http_status
import gossamer/iterator
import gossamer/promise
import gossamer/request
import gossamer/request_redirect
import gossamer/response
import gossamer/response_type
import gossamer/uint8_array

import gleeunit/should

pub fn headers_new_test() {
  let hdrs = headers.new()
  headers.has(hdrs, "content-type") |> should.equal(Ok(False))
}

pub fn headers_from_pairs_test() {
  let assert Ok(hdrs) = headers.from_pairs([#("content-type", "text/plain")])
  headers.get(hdrs, "content-type") |> should.equal(Ok("text/plain"))
}

pub fn headers_append_test() {
  let hdrs = headers.new()
  let assert Ok(_) = headers.append(hdrs, "x-custom", "value1")
  let assert Ok(_) = headers.append(hdrs, "x-custom", "value2")
  headers.get(hdrs, "x-custom")
  |> should.equal(Ok("value1, value2"))
}

pub fn headers_set_test() {
  let hdrs = headers.new()
  let assert Ok(_) = headers.set(hdrs, "x-custom", "value1")
  let assert Ok(_) = headers.set(hdrs, "x-custom", "value2")
  headers.get(hdrs, "x-custom") |> should.equal(Ok("value2"))
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

pub fn request_new_test() {
  let assert Ok(req) = request.new("https://example.org/foo")
  request.method(req) |> should.equal(http_method.Get)
  request.url(req) |> should.equal("https://example.org/foo")
}

pub fn request_new_with_init_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request.Method(http_method.Post),
    ])
  request.method(req) |> should.equal(http_method.Post)
}

pub fn request_headers_test() {
  let assert Ok(hdrs) =
    headers.from_pairs([#("content-type", "application/json")])
  let assert Ok(req) =
    request.new_with_init("https://example.org", [request.Headers(hdrs)])
  headers.get(request.headers(req), "content-type")
  |> should.equal(Ok("application/json"))
}

pub fn request_text_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request.Method(http_method.Post),
      request.Body("hello"),
    ])
  use text <- promise.then(request.text(req))
  should.equal(text, Ok("hello"))
}

pub fn response_new_test() {
  let resp = response.new("hello")
  response.status(resp) |> should.equal(http_status.Ok)
  response.is_ok(resp) |> should.be_true()
}

pub fn response_new_with_init_test() {
  let assert Ok(resp) =
    response.new_with_init("not found", [
      response.Status(http_status.NotFound),
      response.StatusText("Not Found"),
    ])
  response.status(resp) |> should.equal(http_status.NotFound)
  response.status_text(resp) |> should.equal("Not Found")
  response.is_ok(resp) |> should.be_false()
}

pub fn response_text_test() {
  let resp = response.new("hello world")
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

pub fn response_clone_test() {
  let resp = response.new("hello")
  let assert Ok(cloned) = response.clone(resp)
  use text <- promise.then(response.text(cloned))
  should.equal(text, Ok("hello"))
}

pub fn response_get_not_found_test() {
  let assert Ok(resp) =
    response.new_with_init("", [response.Status(http_status.NotFound)])
  response.is_ok(resp) |> should.be_false()
  response.status(resp) |> should.equal(http_status.NotFound)
}

pub fn request_blob_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request.Method(http_method.Post),
      request.Body("blob content"),
    ])
  use result <- promise.then(request.blob(req))
  let assert Ok(b) = result
  should.equal(blob.size(b), 12)
  promise.resolve(Nil)
}

pub fn response_blob_test() {
  let resp = response.new("blob response")
  use result <- promise.then(response.blob(resp))
  let assert Ok(b) = result
  should.equal(blob.size(b), 13)
  promise.resolve(Nil)
}

pub fn request_form_data_test() {
  let assert Ok(hdrs) =
    headers.from_pairs([
      #("content-type", "application/x-www-form-urlencoded"),
    ])
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request.Method(http_method.Post),
      request.Headers(hdrs),
      request.Body("key=value&foo=bar"),
    ])
  use result <- promise.then(request.form_data(req))
  let assert Ok(_fd) = result
  promise.resolve(Nil)
}

pub fn response_form_data_test() {
  let assert Ok(hdrs) =
    headers.from_pairs([
      #("content-type", "application/x-www-form-urlencoded"),
    ])
  let assert Ok(resp) =
    response.new_with_init("key=value", [response.Headers(hdrs)])
  use result <- promise.then(response.form_data(resp))
  let assert Ok(_fd) = result
  promise.resolve(Nil)
}

// Headers additional tests

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

// Request property tests

pub fn request_cache_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _cache = request.cache(req)
}

pub fn request_credentials_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _creds = request.credentials(req)
}

pub fn request_destination_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _destination = request.destination(req)
}

pub fn request_redirect_test() {
  let assert Ok(req) = request.new("https://example.org")
  request.redirect(req) |> should.equal(request_redirect.Follow)
}

pub fn request_signal_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _signal = request.signal(req)
}

pub fn request_referrer_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _referrer = request.referrer(req)
}

pub fn request_referrer_policy_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _referrer_policy = request.referrer_policy(req)
}

pub fn request_mode_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _mode = request.mode(req)
}

pub fn request_is_keepalive_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _keepalive = request.is_keepalive(req)
}

pub fn request_integrity_test() {
  let assert Ok(req) = request.new("https://example.org")
  let _integrity = request.integrity(req)
}

pub fn request_clone_test() {
  let assert Ok(req) = request.new("https://example.org")
  let assert Ok(cloned) = request.clone(req)
  request.url(cloned) |> should.equal("https://example.org/")
}

pub fn request_is_body_used_test() {
  let assert Ok(req) = request.new("https://example.org")
  request.is_body_used(req) |> should.be_false
}

pub fn request_array_buffer_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request.Method(http_method.Post),
      request.Body("hi"),
    ])
  use result <- promise.then(request.array_buffer(req))
  let assert Ok(buffer) = result
  array_buffer.byte_length(buffer) |> should.equal(2)
  promise.resolve(Nil)
}

pub fn request_bytes_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request.Method(http_method.Post),
      request.Body("abc"),
    ])
  use result <- promise.then(request.bytes(req))
  let assert Ok(bytes) = result
  uint8_array.byte_length(bytes) |> should.equal(3)
  promise.resolve(Nil)
}

pub fn request_json_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request.Method(http_method.Post),
      request.Body("{\"a\":1}"),
    ])
  use result <- promise.then(request.json(req))
  should.be_ok(result)
  promise.resolve(Nil)
}

// Response additional body tests

pub fn response_from_json_test() {
  let assert Ok(resp) = response.from_json(42, [])
  response.status(resp) |> should.equal(http_status.Ok)
  use result <- promise.then(response.text(resp))
  should.equal(result, Ok("42"))
  promise.resolve(Nil)
}

pub fn response_is_body_used_test() {
  let resp = response.new("hello")
  response.is_body_used(resp) |> should.be_false
}

pub fn response_body_test() {
  let resp = response.new("hello")
  response.body(resp) |> should.be_ok
}

pub fn response_array_buffer_test() {
  let resp = response.new("hi")
  use result <- promise.then(response.array_buffer(resp))
  let assert Ok(buffer) = result
  array_buffer.byte_length(buffer) |> should.equal(2)
  promise.resolve(Nil)
}

pub fn response_bytes_test() {
  let resp = response.new("abc")
  use result <- promise.then(response.bytes(resp))
  let assert Ok(bytes) = result
  uint8_array.byte_length(bytes) |> should.equal(3)
  promise.resolve(Nil)
}

pub fn response_json_test() {
  let assert Ok(hdrs) =
    headers.from_pairs([#("content-type", "application/json")])
  let assert Ok(resp) =
    response.new_with_init("{\"a\":1}", [response.Headers(hdrs)])
  use result <- promise.then(response.json(resp))
  should.be_ok(result)
  promise.resolve(Nil)
}

pub fn response_is_redirected_test() {
  let resp = response.new("hello")
  response.is_redirected(resp) |> should.be_false
}

pub fn response_url_test() {
  let resp = response.new("hello")
  response.url(resp) |> should.equal("")
}
