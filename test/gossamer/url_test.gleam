import gleam/option.{None, Some}
import gleam/uri
import gleeunit/should
import gossamer/url

pub fn parse_test() {
  let assert Ok(parsed) =
    url.parse("https://example.org/path?q=1", relative_to: None)
  parsed.scheme |> should.equal(Some("https"))
  parsed.host |> should.equal(Some("example.org"))
  parsed.path |> should.equal("/path")
  parsed.query |> should.equal(Some("q=1"))
}

pub fn parse_canonicalizes_test() {
  // WHATWG normalization the permissive `gleam/uri.parse` doesn't do:
  // host lowercased, default port dropped, dot segments resolved.
  let assert Ok(parsed) =
    url.parse("HTTPS://Example.COM:443/a/./b/../c", relative_to: None)
  parsed.scheme |> should.equal(Some("https"))
  parsed.host |> should.equal(Some("example.com"))
  parsed.port |> should.equal(None)
  parsed.path |> should.equal("/a/c")
}

pub fn parse_with_base_test() {
  let assert Ok(parsed) =
    url.parse("/a/b", relative_to: Some("https://example.org/x/y"))
  parsed.host |> should.equal(Some("example.org"))
  parsed.path |> should.equal("/a/b")
}

pub fn parse_ipv6_test() {
  let assert Ok(parsed) = url.parse("https://[::1]:8080/x", relative_to: None)
  parsed.port |> should.equal(Some(8080))
  parsed.path |> should.equal("/x")
}

pub fn parse_userinfo_query_fragment_test() {
  let assert Ok(parsed) =
    url.parse("https://user:pw@example.org/p?q=1#frag", relative_to: None)
  parsed.userinfo |> should.equal(Some("user:pw"))
  parsed.query |> should.equal(Some("q=1"))
  parsed.fragment |> should.equal(Some("frag"))
}

pub fn parse_relative_is_error_test() {
  // The WHATWG URL parser rejects relative URLs (no scheme) when no base
  // is given, unlike the permissive `gleam/uri.parse`.
  url.parse("/path", relative_to: None) |> should.be_error
}

pub fn parse_invalid_test() {
  url.parse("not a url", relative_to: None) |> should.be_error
}

pub fn is_valid_test() {
  url.is_valid("https://example.org", relative_to: None) |> should.be_true
  url.is_valid("ws://localhost:8080", relative_to: None) |> should.be_true
}

pub fn is_valid_rejects_relative_test() {
  url.is_valid("/path", relative_to: None) |> should.be_false
  url.is_valid("example.org", relative_to: None) |> should.be_false
  url.is_valid("not a url", relative_to: None) |> should.be_false
}

pub fn is_valid_with_base_test() {
  url.is_valid("/path", relative_to: Some("https://example.org"))
  |> should.be_true
  url.is_valid("/path", relative_to: Some("not a url")) |> should.be_false
}

pub fn parse_round_trip_via_uri_test() {
  let href = "https://example.org/path?q=1"
  let assert Ok(parsed) = url.parse(href, relative_to: None)
  parsed |> uri.to_string |> should.equal(href)
}
