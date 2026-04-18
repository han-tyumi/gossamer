import gleam/string
import gleeunit/should
import gossamer/blob
import gossamer/iterator
import gossamer/url
import gossamer/url_search_params

pub fn new_test() {
  let assert Ok(parsed) = url.new("https://example.org/foo")
  url.href(parsed) |> should.equal("https://example.org/foo")
}

pub fn new_with_base_test() {
  let assert Ok(parsed) = url.new_with_base("/bar", "https://example.org")
  url.href(parsed) |> should.equal("https://example.org/bar")
}

pub fn parse_test() {
  url.parse("https://example.org") |> should.be_ok
}

pub fn parse_invalid_test() {
  url.parse("not a url") |> should.equal(Error(Nil))
}

pub fn can_parse_test() {
  url.can_parse("https://example.org") |> should.be_true()
  url.can_parse("not a url") |> should.be_false()
}

pub fn properties_test() {
  let assert Ok(parsed) =
    url.new("https://user:pass@example.org:8080/path?q=1#hash")
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
  let assert Ok(parsed) = url.new("https://example.org/foo")
  url.set_pathname(parsed, "/bar")
  url.pathname(parsed) |> should.equal("/bar")
}

pub fn search_params_test() {
  let assert Ok(parsed) = url.new("https://example.org?a=1&b=2")
  let params = url.search_params(parsed)
  url_search_params.get(params, "a") |> should.equal(Ok("1"))
  url_search_params.get(params, "b") |> should.equal(Ok("2"))
}

pub fn to_string_test() {
  let assert Ok(parsed) = url.new("https://example.org/foo")
  url.to_string(parsed) |> should.equal("https://example.org/foo")
}

pub fn url_search_params_new_test() {
  let params = url_search_params.new()
  url_search_params.size(params) |> should.equal(0)
}

pub fn url_search_params_from_string_test() {
  let params = url_search_params.from_string("foo=bar&baz=qux")
  url_search_params.get(params, "foo") |> should.equal(Ok("bar"))
  url_search_params.get(params, "baz") |> should.equal(Ok("qux"))
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
  url_search_params.get(params, "a") |> should.equal(Ok("2"))
}

pub fn url_search_params_sort_test() {
  let params = url_search_params.from_string("c=3&a=1&b=2")
  url_search_params.sort(params)
  url_search_params.to_string(params) |> should.equal("a=1&b=2&c=3")
}

pub fn url_search_params_keys_test() {
  let params = url_search_params.from_string("a=1&b=2")
  url_search_params.keys(params) |> iterator.to_list |> should.equal(["a", "b"])
}

pub fn url_search_params_entries_test() {
  let params = url_search_params.from_string("a=1&b=2")
  url_search_params.entries(params)
  |> iterator.to_list
  |> should.equal([#("a", "1"), #("b", "2")])
}

// URL setter tests

pub fn set_hash_test() {
  let assert Ok(parsed) = url.new("https://example.org")
  url.set_hash(parsed, "#section")
  url.hash(parsed) |> should.equal("#section")
}

pub fn set_host_test() {
  let assert Ok(parsed) = url.new("https://example.org")
  url.set_host(parsed, "other.org:9090")
  url.host(parsed) |> should.equal("other.org:9090")
}

pub fn set_hostname_test() {
  let assert Ok(parsed) = url.new("https://example.org")
  url.set_hostname(parsed, "other.org")
  url.hostname(parsed) |> should.equal("other.org")
}

pub fn set_href_test() {
  let assert Ok(parsed) = url.new("https://example.org/old")
  url.set_href(parsed, "https://other.org/new")
  url.href(parsed) |> should.equal("https://other.org/new")
}

pub fn set_password_test() {
  let assert Ok(parsed) = url.new("https://user@example.org")
  url.set_password(parsed, "secret")
  url.password(parsed) |> should.equal("secret")
}

pub fn set_port_test() {
  let assert Ok(parsed) = url.new("https://example.org")
  url.set_port(parsed, "8080")
  url.port(parsed) |> should.equal("8080")
}

pub fn set_protocol_test() {
  let assert Ok(parsed) = url.new("https://example.org")
  url.set_protocol(parsed, "http:")
  url.protocol(parsed) |> should.equal("http:")
}

pub fn set_search_test() {
  let assert Ok(parsed) = url.new("https://example.org")
  url.set_search(parsed, "?q=hello")
  url.search(parsed) |> should.equal("?q=hello")
}

pub fn set_username_test() {
  let assert Ok(parsed) = url.new("https://example.org")
  url.set_username(parsed, "admin")
  url.username(parsed) |> should.equal("admin")
}

pub fn parse_with_base_test() {
  url.parse_with_base("/bar", "https://example.org") |> should.be_ok
}

pub fn parse_with_base_invalid_test() {
  url.parse_with_base("://bad", "also bad") |> should.equal(Error(Nil))
}

pub fn can_parse_with_base_test() {
  url.can_parse_with_base("/path", "https://example.org") |> should.be_true
  url.can_parse_with_base("://bad", "also bad") |> should.be_false
}

pub fn to_json_test() {
  let assert Ok(parsed) = url.new("https://example.org/foo")
  url.to_json(parsed) |> should.equal("https://example.org/foo")
}

// URLSearchParams additional tests

pub fn url_search_params_delete_value_test() {
  let params = url_search_params.from_string("a=1&a=2&b=3")
  url_search_params.delete_value(params, "a", "1")
  url_search_params.get_all(params, "a") |> should.equal(["2"])
  url_search_params.has(params, "b") |> should.be_true
}

pub fn url_search_params_has_value_test() {
  let params = url_search_params.from_string("a=1&a=2")
  url_search_params.has_value(params, "a", "1") |> should.be_true
  url_search_params.has_value(params, "a", "3") |> should.be_false
}

pub fn url_search_params_values_test() {
  let params = url_search_params.from_string("a=1&b=2")
  url_search_params.values(params)
  |> iterator.to_list
  |> should.equal(["1", "2"])
}

pub fn url_search_params_for_each_test() {
  let params = url_search_params.from_string("a=1")
  url_search_params.for_each(params, fn(_name, _value) { Nil })
}

pub fn create_object_url_test() {
  let test_blob = blob.from_string("hello")

  url.create_object_url(test_blob)
  |> string.starts_with("blob:")
  |> should.be_true
}

pub fn revoke_object_url_test() {
  let test_blob = blob.from_string("hello")
  let object_url = url.create_object_url(test_blob)
  url.revoke_object_url(object_url)
}
