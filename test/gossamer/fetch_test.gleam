import gleam/option.{None, Some}
import gossamer/abort_signal
import gossamer/array_buffer
import gossamer/blob
import gossamer/form_data
import gossamer/headers
import gossamer/http_method
import gossamer/http_status
import gossamer/iterator
import gossamer/promise
import gossamer/readable_stream
import gossamer/readable_stream/default_controller
import gossamer/referrer_policy
import gossamer/request
import gossamer/request_cache
import gossamer/request_credentials
import gossamer/request_destination
import gossamer/request_mode
import gossamer/request_priority
import gossamer/request_redirect
import gossamer/response
import gossamer/response_type
import gossamer/uint8_array
import gossamer/url
import gossamer/url_search_params

import gleeunit/should
import runtime

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

pub fn request_from_url_string_test() {
  let assert Ok(req) = request.from_url_string("https://example.org/foo")
  req.method |> should.equal(http_method.Get)
  req.url |> should.equal("https://example.org/foo")
}

pub fn request_from_url_string_with_test() {
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
    ])
  req.method |> should.equal(http_method.Post)
}

pub fn request_headers_test() {
  let assert Ok(hdrs) =
    headers.from_pairs([#("content-type", "application/json")])
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Headers(hdrs),
    ])
  headers.get(req.headers, "content-type")
  |> should.equal(Ok(Some("application/json")))
}

pub fn request_text_test() {
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.Body("hello"),
    ])
  use text <- promise.then(request.text(req))
  should.equal(text, Ok("hello"))
}

pub fn request_body_bytes_test() {
  let bytes = uint8_array.from_list([104, 105])
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.BodyBytes(bytes),
    ])
  use text <- promise.then(request.text(req))
  should.equal(text, Ok("hi"))
  promise.resolve(Nil)
}

pub fn request_body_blob_test() {
  let b = blob.from_string("blob body")
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.BodyBlob(b),
    ])
  use text <- promise.then(request.text(req))
  should.equal(text, Ok("blob body"))
  promise.resolve(Nil)
}

pub fn request_body_buffer_test() {
  let bytes = uint8_array.from_list([97, 98, 99])
  let buffer = uint8_array.buffer(bytes)
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.BodyBuffer(buffer),
    ])
  use text <- promise.then(request.text(req))
  should.equal(text, Ok("abc"))
  promise.resolve(Nil)
}

pub fn request_body_params_test() {
  let params = url_search_params.from_string("a=1&b=2")
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.BodyParams(params),
    ])
  use text <- promise.then(request.text(req))
  should.equal(text, Ok("a=1&b=2"))
  promise.resolve(Nil)
}

pub fn request_body_form_data_test() {
  let fd = form_data.new() |> form_data.append("key", "value")
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.BodyFormData(fd),
    ])
  use result <- promise.then(request.form_data(req))
  should.be_ok(result)
  promise.resolve(Nil)
}

pub fn request_from_url_test() {
  let assert Ok(u) = url.new("https://example.org")
  let assert Ok(req) = request.from_url(u)
  req.url |> should.equal("https://example.org/")
}

pub fn request_from_url_with_test() {
  let assert Ok(u) = url.new("https://example.org")
  let assert Ok(req) =
    request.from_url_with(u, [request.Method(http_method.Post)])
  req.method |> should.equal(http_method.Post)
}

pub fn request_from_request_test() {
  let assert Ok(original) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
    ])
  let assert Ok(copy) = request.from_request(original)
  copy.method |> should.equal(http_method.Post)
  copy.url |> should.equal("https://example.org/")
}

pub fn request_from_request_with_test() {
  let assert Ok(original) = request.from_url_string("https://example.org")
  let assert Ok(overridden) =
    request.from_request_with(original, [
      request.Method(http_method.Put),
    ])
  overridden.method |> should.equal(http_method.Put)
}

pub fn request_body_stream_test() {
  let bytes = uint8_array.from_list([104, 105])
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let assert Ok(_) = default_controller.enqueue(controller, bytes)
      let assert Ok(_) = default_controller.close(controller)
      Nil
    })
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.BodyStream(stream),
    ])
  use text <- promise.then(request.text(req))
  should.equal(text, Ok("hi"))
  promise.resolve(Nil)
}

pub fn response_from_string_test() {
  let resp = response.from_string("hello")
  resp.status |> should.equal(http_status.Ok)
  resp.is_ok |> should.be_true()
}

pub fn response_from_string_with_test() {
  let assert Ok(resp) =
    response.from_string_with("not found", [
      response.Status(http_status.NotFound),
      response.StatusText("Not Found"),
    ])
  resp.status |> should.equal(http_status.NotFound)
  resp.status_text |> should.equal("Not Found")
  resp.is_ok |> should.be_false()
}

pub fn response_text_test() {
  let resp = response.from_string("hello world")
  use text <- promise.then(response.text(resp))
  should.equal(text, Ok("hello world"))
}

pub fn response_error_test() {
  let resp = response.error()
  resp.type_ |> should.equal(response_type.Error)
}

pub fn response_redirect_test() {
  let assert Ok(resp) =
    response.redirect_with_status(
      "https://example.org",
      http_status.MovedPermanently,
    )
  resp.status |> should.equal(http_status.MovedPermanently)
}

pub fn response_redirect_url_test() {
  let assert Ok(u) = url.new("https://example.org")
  let resp = response.redirect_url(u)
  resp.status |> should.equal(http_status.Found)
}

pub fn response_redirect_url_with_status_test() {
  let assert Ok(u) = url.new("https://example.org")
  let assert Ok(resp) =
    response.redirect_url_with_status(u, http_status.MovedPermanently)
  resp.status |> should.equal(http_status.MovedPermanently)
}

pub fn response_redirect_parity_test() {
  // String-input and URL-input redirect variants produce responses with
  // the same observable location header and status.
  let location = "https://example.org/new"
  let assert Ok(u) = url.new(location)

  let assert Ok(from_string) = response.redirect(location)
  let from_url = response.redirect_url(u)

  let hdr = fn(r: response.Response) {
    let assert Ok(Some(h)) = headers.get(r.headers, "location")
    h
  }
  hdr(from_string) |> should.equal(hdr(from_url))
  from_string.status |> should.equal(from_url.status)
}

pub fn request_from_url_parity_test() {
  // String and URL input produce Requests with the same observable url.
  let href = "https://example.org/foo"
  let assert Ok(u) = url.new(href)

  let assert Ok(from_string) = request.from_url_string(href)
  let assert Ok(from_url) = request.from_url(u)

  from_string.url |> should.equal(from_url.url)
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
  resp.is_ok |> should.be_false()
  resp.status |> should.equal(http_status.NotFound)
}

pub fn request_blob_test() {
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.Body("blob content"),
    ])
  use result <- promise.then(request.blob(req))
  let assert Ok(b) = result
  b.size |> should.equal(12)
  promise.resolve(Nil)
}

pub fn response_blob_test() {
  let resp = response.from_string("blob response")
  use result <- promise.then(response.blob(resp))
  let assert Ok(b) = result
  b.size |> should.equal(13)
  promise.resolve(Nil)
}

pub fn request_form_data_test() {
  let assert Ok(hdrs) =
    headers.from_pairs([
      #("content-type", "application/x-www-form-urlencoded"),
    ])
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
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
    response.from_string_with("key=value", [response.Headers(hdrs)])
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
  let assert Ok(req) = request.from_url_string("https://example.org")
  req.cache |> should.equal(request_cache.Default)
}

pub fn request_credentials_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  case runtime.current() {
    runtime.Bun -> req.credentials |> should.equal(request_credentials.Include)
    _ -> req.credentials |> should.equal(request_credentials.SameOrigin)
  }
}

pub fn request_destination_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  req.destination |> should.equal(request_destination.Empty)
}

pub fn request_redirect_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  req.redirect |> should.equal(request_redirect.Follow)
}

pub fn request_signal_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  abort_signal.is_aborted(req.signal) |> should.be_false
}

pub fn request_referrer_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  case runtime.current() {
    runtime.Bun -> req.referrer |> should.equal("")
    _ -> req.referrer |> should.equal("about:client")
  }
}

pub fn request_referrer_policy_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  req.referrer_policy
  |> should.equal(referrer_policy.StrictOriginWhenCrossOrigin)
}

pub fn request_mode_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  req.mode |> should.equal(request_mode.Cors)
}

pub fn request_priority_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  req.priority |> should.equal(request_priority.Auto)
}

pub fn request_init_priority_test() {
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
      request.Priority(request_priority.High),
    ])

  // Reads back as `Auto` on all runtimes — see `priority` field doc.
  req.priority |> should.equal(request_priority.Auto)
}

pub fn request_is_keepalive_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  req.is_keepalive |> should.be_false
}

pub fn request_integrity_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  req.integrity |> should.equal("")
}

pub fn request_clone_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  let assert Ok(cloned) = request.clone(req)
  cloned.url |> should.equal("https://example.org/")
}

pub fn request_is_body_used_test() {
  let assert Ok(req) = request.from_url_string("https://example.org")
  request.is_body_used(req) |> should.be_false
}

pub fn request_array_buffer_test() {
  let assert Ok(req) =
    request.from_url_string_with("https://example.org", [
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
    request.from_url_string_with("https://example.org", [
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
    request.from_url_string_with("https://example.org", [
      request.Method(http_method.Post),
      request.Body("{\"a\":1}"),
    ])
  use result <- promise.then(request.json(req))
  should.be_ok(result)
  promise.resolve(Nil)
}

// Response additional body tests

pub fn response_from_json_test() {
  let assert Ok(resp) = response.from_json(42)
  resp.status |> should.equal(http_status.Ok)
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
  resp.body |> should.be_some
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
  resp.is_redirected |> should.be_false
}

pub fn response_url_test() {
  let resp = response.from_string("hello")
  resp.url |> should.equal("")
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
    response.from_bytes_with(bytes, [
      response.Status(http_status.Created),
    ])
  resp.status |> should.equal(http_status.Created)
}

pub fn response_from_blob_test() {
  let b = blob.from_string("hello")
  let resp = response.from_blob(b)
  use result <- promise.then(response.text(resp))
  should.equal(result, Ok("hello"))
  promise.resolve(Nil)
}

pub fn response_from_buffer_test() {
  let bytes = uint8_array.from_list([97, 98, 99])
  let buffer = uint8_array.buffer(bytes)
  let resp = response.from_buffer(buffer)
  use result <- promise.then(response.text(resp))
  should.equal(result, Ok("abc"))
  promise.resolve(Nil)
}

pub fn response_from_form_data_test() {
  let fd = form_data.new()
  let fd = form_data.append(fd, "key", "value")
  let resp = response.from_form_data(fd)
  resp.status |> should.equal(http_status.Ok)
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
  resp.status |> should.equal(http_status.Created)
}
