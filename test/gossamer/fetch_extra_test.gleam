import gleam/fetch.{type FetchBody}
import gleam/fetch/form_data
import gleam/http
import gleam/http/request
import gleam/http/response.{type Response}
import gleam/javascript/promise.{type Promise}
import gleeunit/should
import gossamer/abort_signal
import gossamer/fetch_extra
import gossamer/fetch_options
import gossamer/readable_stream
import gossamer/readable_stream/default_controller
import gossamer/response_type
import runtime

@external(javascript, "./fetch_extra_test.ffi.mjs", "make_test_response")
fn make_test_response() -> Promise(Response(FetchBody))

pub fn is_response_ok_2xx_test() {
  let resp_200 = response.new(200) |> response.set_body("ok")
  let resp_201 = response.new(201) |> response.set_body("created")
  let resp_299 = response.new(299) |> response.set_body("edge")
  fetch_extra.is_response_ok(resp_200) |> should.be_true
  fetch_extra.is_response_ok(resp_201) |> should.be_true
  fetch_extra.is_response_ok(resp_299) |> should.be_true
}

pub fn is_response_ok_non_2xx_test() {
  let resp_100 = response.new(100) |> response.set_body("info")
  let resp_199 = response.new(199) |> response.set_body("edge")
  let resp_300 = response.new(300) |> response.set_body("redirect")
  let resp_404 = response.new(404) |> response.set_body("not found")
  let resp_500 = response.new(500) |> response.set_body("error")
  fetch_extra.is_response_ok(resp_100) |> should.be_false
  fetch_extra.is_response_ok(resp_199) |> should.be_false
  fetch_extra.is_response_ok(resp_300) |> should.be_false
  fetch_extra.is_response_ok(resp_404) |> should.be_false
  fetch_extra.is_response_ok(resp_500) |> should.be_false
}

pub fn is_response_ok_polymorphic_test() {
  // Works on any `Response(body)`, including non-string body types.
  let with_int = response.new(204) |> response.set_body(42)
  let with_list = response.new(404) |> response.set_body([1, 2, 3])
  fetch_extra.is_response_ok(with_int) |> should.be_true
  fetch_extra.is_response_ok(with_list) |> should.be_false
}

pub fn send_aborted_signal_yields_network_error_test() {
  let req =
    request.new()
    |> request.set_method(http.Get)
    |> request.set_host("example.com")
    |> request.set_path("/")

  let signal = abort_signal.abort("pre-aborted")
  let opts = fetch_options.new() |> fetch_options.set_signal(signal)

  use result <- promise.await(fetch_extra.send(req, with: opts))
  let assert Error(fetch.NetworkError(_)) = result
  promise.resolve(Nil)
}

pub fn send_bits_aborted_signal_yields_network_error_test() {
  let req =
    request.new()
    |> request.set_method(http.Post)
    |> request.set_host("example.com")
    |> request.set_path("/")
    |> request.set_body(<<"payload">>)

  let signal = abort_signal.abort("pre-aborted")
  let opts = fetch_options.new() |> fetch_options.set_signal(signal)

  use result <- promise.await(fetch_extra.send_bits(req, with: opts))
  let assert Error(fetch.NetworkError(_)) = result
  promise.resolve(Nil)
}

pub fn send_form_data_aborted_signal_yields_network_error_test() {
  let body = form_data.new() |> form_data.append("key", "value")
  let req =
    request.new()
    |> request.set_method(http.Post)
    |> request.set_host("example.com")
    |> request.set_path("/")
    |> request.set_body(body)

  let signal = abort_signal.abort("pre-aborted")
  let opts = fetch_options.new() |> fetch_options.set_signal(signal)

  use result <- promise.await(fetch_extra.send_form_data(req, with: opts))
  let assert Error(fetch.NetworkError(_)) = result
  promise.resolve(Nil)
}

pub fn send_stream_aborted_signal_yields_network_error_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let assert Ok(_) = default_controller.enqueue(controller, <<"payload">>)
      let assert Ok(_) = default_controller.close(controller)
      Nil
    })
  let req =
    request.new()
    |> request.set_method(http.Post)
    |> request.set_host("example.com")
    |> request.set_path("/")
    |> request.set_body(stream)

  let signal = abort_signal.abort("pre-aborted")
  let opts = fetch_options.new() |> fetch_options.set_signal(signal)

  use result <- promise.await(fetch_extra.send_stream(req, with: opts))
  let assert Error(fetch.NetworkError(_)) = result
  promise.resolve(Nil)
}

pub fn response_url_test() {
  use response <- promise.await(make_test_response())
  fetch_extra.response_url(response)
  |> should.equal("data:text/plain,hello")
  promise.resolve(Nil)
}

pub fn is_response_redirected_test() {
  use response <- promise.await(make_test_response())
  fetch_extra.is_response_redirected(response) |> should.be_false
  promise.resolve(Nil)
}

pub fn response_type_test() {
  use <- runtime.skip_on(runtime.Bun)
  use response <- promise.await(make_test_response())
  fetch_extra.response_type(response) |> should.equal(response_type.Basic)
  promise.resolve(Nil)
}

/// Bun reports `type: "default"` for synthetic data-URL responses where
/// the Fetch spec (and Deno and Node) say `"basic"`. Asserting the wrong
/// value here means this test starts failing the moment Bun aligns,
/// surfacing the fix so the divergence handling can be removed.
pub fn response_type_bun_divergence_test() {
  use <- runtime.only_on(runtime.Bun)
  use response <- promise.await(make_test_response())
  fetch_extra.response_type(response) |> should.equal(response_type.Default)
  promise.resolve(Nil)
}

pub fn is_response_body_used_flips_after_consumption_test() {
  use response <- promise.await(make_test_response())
  fetch_extra.is_response_body_used(response) |> should.be_false
  use _ <- promise.await(fetch.read_text_body(response))
  fetch_extra.is_response_body_used(response) |> should.be_true
  promise.resolve(Nil)
}
