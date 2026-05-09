import gleam/option.{Some}
import gleam/uri
import gleeunit/should
import gossamer/url

pub fn parse_test() {
  let assert Ok(parsed) = url.parse("https://example.org/path?q=1")
  parsed.scheme |> should.equal(Some("https"))
  parsed.host |> should.equal(Some("example.org"))
  parsed.path |> should.equal("/path")
  parsed.query |> should.equal(Some("q=1"))
}

pub fn parse_relative_is_error_test() {
  // The WHATWG URL parser rejects relative URLs (no scheme), unlike the
  // permissive `gleam/uri.parse`.
  url.parse("/path") |> should.be_error
}

pub fn parse_invalid_test() {
  url.parse("not a url") |> should.be_error
}

pub fn is_valid_test() {
  url.is_valid("https://example.org") |> should.be_true
  url.is_valid("ws://localhost:8080") |> should.be_true
}

pub fn is_valid_rejects_relative_test() {
  url.is_valid("/path") |> should.be_false
  url.is_valid("example.org") |> should.be_false
  url.is_valid("not a url") |> should.be_false
}

pub fn parse_round_trip_via_uri_test() {
  let href = "https://example.org/path?q=1"
  let assert Ok(parsed) = url.parse(href)
  parsed |> uri.to_string |> should.equal(href)
}
