import gossamer/headers
import gossamer/promise
import gossamer/request
import gossamer/request_init
import gossamer/response
import gossamer/response_init

import gleeunit/should

pub fn headers_new_test() {
  let hdrs = headers.new()
  headers.has(hdrs, "content-type") |> should.be_false()
}

pub fn headers_from_pairs_test() {
  let hdrs = headers.from_pairs([#("content-type", "text/plain")])
  headers.get(hdrs, "content-type") |> should.equal(Ok("text/plain"))
}

pub fn headers_append_test() {
  let hdrs = headers.new()
  headers.append(hdrs, "x-custom", "value1")
  headers.append(hdrs, "x-custom", "value2")
  headers.get(hdrs, "x-custom")
  |> should.equal(Ok("value1, value2"))
}

pub fn headers_set_test() {
  let hdrs = headers.new()
  headers.set(hdrs, "x-custom", "value1")
  headers.set(hdrs, "x-custom", "value2")
  headers.get(hdrs, "x-custom") |> should.equal(Ok("value2"))
}

pub fn headers_delete_test() {
  let hdrs = headers.from_pairs([#("x-custom", "value")])
  headers.delete(hdrs, "x-custom")
  headers.has(hdrs, "x-custom") |> should.be_false()
}

pub fn headers_keys_test() {
  let hdrs = headers.from_pairs([#("b", "2"), #("a", "1")])
  headers.keys(hdrs) |> should.equal(["a", "b"])
}

pub fn headers_entries_test() {
  let hdrs = headers.from_pairs([#("a", "1")])
  headers.entries(hdrs) |> should.equal([#("a", "1")])
}

pub fn request_new_test() {
  let assert Ok(req) = request.new("https://example.org/foo")
  request.method(req) |> should.equal("GET")
  request.url(req) |> should.equal("https://example.org/foo")
}

pub fn request_new_with_init_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request_init.Method("POST"),
    ])
  request.method(req) |> should.equal("POST")
}

pub fn request_headers_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request_init.Headers(
        headers.from_pairs([#("content-type", "application/json")]),
      ),
    ])
  headers.get(request.headers(req), "content-type")
  |> should.equal(Ok("application/json"))
}

pub fn request_text_test() {
  let assert Ok(req) =
    request.new_with_init("https://example.org", [
      request_init.Method("POST"),
      request_init.Body("hello"),
    ])
  use text <- promise.then(request.text(req))
  should.equal(text, Ok("hello"))
}

pub fn response_new_test() {
  let assert Ok(resp) = response.new("hello")
  response.status(resp) |> should.equal(200)
  response.is_ok(resp) |> should.be_true()
}

pub fn response_new_with_init_test() {
  let assert Ok(resp) =
    response.new_with_init("not found", [
      response_init.Status(404),
      response_init.StatusText("Not Found"),
    ])
  response.status(resp) |> should.equal(404)
  response.status_text(resp) |> should.equal("Not Found")
  response.is_ok(resp) |> should.be_false()
}

pub fn response_text_test() {
  let assert Ok(resp) = response.new("hello world")
  use text <- promise.then(response.text(resp))
  should.equal(text, Ok("hello world"))
}

pub fn response_error_test() {
  let resp = response.error()
  response.type_(resp) |> should.equal("error")
}

pub fn response_redirect_test() {
  let resp = response.redirect_with_status("https://example.org", 301)
  response.status(resp) |> should.equal(301)
}

pub fn response_clone_test() {
  let assert Ok(resp) = response.new("hello")
  let cloned = response.clone(resp)
  use text <- promise.then(response.text(cloned))
  should.equal(text, Ok("hello"))
}

pub fn response_get_not_found_test() {
  let assert Ok(resp) = response.new_with_init("", [response_init.Status(404)])
  response.is_ok(resp) |> should.be_false()
  response.status(resp) |> should.equal(404)
}
