import gleeunit/should
import gossamer
import gossamer/http_status
import gossamer/promise
import gossamer/request
import gossamer/response
import gossamer/url

pub fn structured_clone_int_test() {
  gossamer.structured_clone(42) |> should.equal(Ok(42))
}

pub fn structured_clone_string_test() {
  gossamer.structured_clone("hello") |> should.equal(Ok("hello"))
}

pub fn structured_clone_tuple_test() {
  gossamer.structured_clone(#(1, "two")) |> should.equal(Ok(#(1, "two")))
}

pub fn btoa_test() {
  gossamer.btoa("Hello") |> should.equal(Ok("SGVsbG8="))
}

pub fn atob_test() {
  gossamer.atob("SGVsbG8=") |> should.equal(Ok("Hello"))
}

pub fn btoa_atob_roundtrip_test() {
  let assert Ok(encoded) = gossamer.btoa("roundtrip test")
  let assert Ok(decoded) = gossamer.atob(encoded)
  should.equal(decoded, "roundtrip test")
}

pub fn atob_invalid_test() {
  gossamer.atob("!!!invalid!!!") |> should.be_error
}

pub fn user_agent_test() {
  let agent = gossamer.user_agent()
  should.be_true(agent != "")
}

pub fn set_timeout_and_clear_test() {
  let resolvers = promise.with_resolvers()

  let id =
    gossamer.set_timeout(10, fn() {
      resolvers.resolve("fired")
      Nil
    })

  // Verify we get a valid timer id.
  should.be_true(id >= 0)

  use value <- promise.then(resolvers.promise)
  should.equal(value, Ok("fired"))
  promise.resolve(Nil)
}

pub fn clear_timeout_test() {
  let id = gossamer.set_timeout(100_000, fn() { Nil })
  gossamer.clear_timeout(id)
}

pub fn set_interval_and_clear_test() {
  let id = gossamer.set_interval(100_000, fn() { Nil })
  should.be_true(id >= 0)
  gossamer.clear_interval(id)
}

pub fn queue_microtask_test() {
  let resolvers = promise.with_resolvers()

  gossamer.queue_microtask(fn() {
    resolvers.resolve("microtask ran")
    Nil
  })

  use value <- promise.then(resolvers.promise)
  should.equal(value, Ok("microtask ran"))
  promise.resolve(Nil)
}

// TODO: Test fetch with other URL schemes (blob:, http: via local server).

pub fn fetch_data_url_test() {
  use result <- promise.then(gossamer.fetch("data:text/plain,hello"))
  let assert Ok(resp) = result
  response.status(resp) |> should.equal(http_status.Ok)
  use text <- promise.then(response.text(resp))
  should.equal(text, Ok("hello"))
  promise.resolve(Nil)
}

pub fn fetch_with_data_url_test() {
  use result <- promise.then(gossamer.fetch_with("data:text/plain,init", []))
  let assert Ok(resp) = result
  use text <- promise.then(response.text(resp))
  should.equal(text, Ok("init"))
  promise.resolve(Nil)
}

pub fn fetch_request_data_url_test() {
  let assert Ok(req) = request.from_url_string("data:text/plain,from_request")
  use result <- promise.then(gossamer.fetch_request(req))
  let assert Ok(resp) = result
  use text <- promise.then(response.text(resp))
  should.equal(text, Ok("from_request"))
  promise.resolve(Nil)
}

pub fn fetch_url_data_url_test() {
  let assert Ok(u) = url.new("data:text/plain,from_url")
  use result <- promise.then(gossamer.fetch_url(u))
  let assert Ok(resp) = result
  use text <- promise.then(response.text(resp))
  should.equal(text, Ok("from_url"))
  promise.resolve(Nil)
}

pub fn fetch_url_with_data_url_test() {
  let assert Ok(u) = url.new("data:text/plain,from_url_init")
  use result <- promise.then(gossamer.fetch_url_with(u, []))
  let assert Ok(resp) = result
  use text <- promise.then(response.text(resp))
  should.equal(text, Ok("from_url_init"))
  promise.resolve(Nil)
}
