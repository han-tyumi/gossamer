import gossamer/url
import gossamer/url_search_params
import gleam/option.{None, Some}
import gleeunit/should

pub fn new_test() {
  let parsed = url.new("https://example.org/foo")
  url.href(parsed) |> should.equal("https://example.org/foo")
}

pub fn new_with_base_test() {
  let parsed = url.new_with_base("/bar", "https://example.org")
  url.href(parsed) |> should.equal("https://example.org/bar")
}

pub fn parse_test() {
  url.parse("https://example.org") |> should.be_some
}

pub fn parse_invalid_test() {
  url.parse("not a url") |> should.equal(None)
}

pub fn can_parse_test() {
  url.can_parse("https://example.org") |> should.be_true()
  url.can_parse("not a url") |> should.be_false()
}

pub fn properties_test() {
  let parsed = url.new("https://user:pass@example.org:8080/path?q=1#hash")
  url.hash(parsed) |> should.equal("#hash")
  url.host(parsed) |> should.equal("example.org:8080")
  url.hostname(parsed) |> should.equal("example.org")
  url.href(parsed)
  |> should.equal("https://user:pass@example.org:8080/path?q=1#hash")
  url.origin(parsed) |> should.equal("https://example.org:8080")
  url.password(parsed) |> should.equal("pass")
  url.pathname(parsed) |> should.equal("/path")
  url.port(parsed) |> should.equal("8080")
  url.protocol(parsed) |> should.equal("https:")
  url.search(parsed) |> should.equal("?q=1")
  url.username(parsed) |> should.equal("user")
}

pub fn set_pathname_test() {
  let parsed = url.new("https://example.org/foo")
  url.set_pathname(parsed, "/bar")
  url.pathname(parsed) |> should.equal("/bar")
}

pub fn search_params_test() {
  let parsed = url.new("https://example.org?a=1&b=2")
  let params = url.search_params(parsed)
  url_search_params.get(params, "a") |> should.equal(Some("1"))
  url_search_params.get(params, "b") |> should.equal(Some("2"))
}

pub fn to_string_test() {
  let parsed = url.new("https://example.org/foo")
  url.to_string(parsed) |> should.equal("https://example.org/foo")
}

pub fn url_search_params_new_test() {
  let params = url_search_params.new()
  url_search_params.size(params) |> should.equal(0)
}

pub fn url_search_params_from_string_test() {
  let params = url_search_params.from_string("foo=bar&baz=qux")
  url_search_params.get(params, "foo") |> should.equal(Some("bar"))
  url_search_params.get(params, "baz") |> should.equal(Some("qux"))
}

pub fn url_search_params_from_pairs_test() {
  let params = url_search_params.from_pairs([#("foo", "1"), #("bar", "2")])
  url_search_params.to_string(params) |> should.equal("foo=1&bar=2")
}

pub fn url_search_params_append_test() {
  let params = url_search_params.new()
  url_search_params.append(params, "name", "first")
  url_search_params.append(params, "name", "second")
  url_search_params.get_all(params, "name") |> should.equal(["first", "second"])
}

pub fn url_search_params_delete_test() {
  let params = url_search_params.from_string("a=1&b=2")
  url_search_params.delete(params, "a")
  url_search_params.has(params, "a") |> should.be_false()
  url_search_params.has(params, "b") |> should.be_true()
}

pub fn url_search_params_set_test() {
  let params = url_search_params.from_string("a=1")
  url_search_params.set(params, "a", "2")
  url_search_params.get(params, "a") |> should.equal(Some("2"))
}

pub fn url_search_params_sort_test() {
  let params = url_search_params.from_string("c=3&a=1&b=2")
  url_search_params.sort(params)
  url_search_params.to_string(params) |> should.equal("a=1&b=2&c=3")
}

pub fn url_search_params_keys_test() {
  let params = url_search_params.from_string("a=1&b=2")
  url_search_params.keys(params) |> should.equal(["a", "b"])
}

pub fn url_search_params_entries_test() {
  let params = url_search_params.from_string("a=1&b=2")
  url_search_params.entries(params)
  |> should.equal([#("a", "1"), #("b", "2")])
}
