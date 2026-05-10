import gleam/dict
import gleeunit/should
import gossamer/url_pattern

pub fn build_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/foo/:id")
    |> url_pattern.build
  url_pattern.pathname(pattern) |> should.equal("/foo/:id")
}

pub fn from_string_test() {
  let assert Ok(pattern) = url_pattern.from_string("https://example.com/*")
  url_pattern.protocol(pattern) |> should.equal("https")
  url_pattern.hostname(pattern) |> should.equal("example.com")
}

pub fn from_string_with_base_test() {
  let assert Ok(pattern) =
    url_pattern.from_string_with_base("/foo/*", "https://example.com")
  url_pattern.hostname(pattern) |> should.equal("example.com")
  url_pattern.pathname(pattern) |> should.equal("/foo/*")
}

pub fn test_match_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/users/:id")
    |> url_pattern.build
  url_pattern.test_(pattern, "https://example.com/users/123")
  |> should.be_true
}

pub fn test_no_match_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/users/:id")
    |> url_pattern.build
  url_pattern.test_(pattern, "https://example.com/posts/123")
  |> should.be_false
}

pub fn test_with_base_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/api/*")
    |> url_pattern.build
  url_pattern.test_with_base(pattern, "/api/data", "https://example.com")
  |> should.be_true
}

pub fn test_with_base_invalid_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/api/*")
    |> url_pattern.build
  url_pattern.test_with_base(pattern, "/api/data", "not a url")
  |> should.be_false
}

pub fn exec_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/users/:id")
    |> url_pattern.build
  let assert Ok(result) =
    url_pattern.exec(pattern, "https://example.com/users/42")
  let pathname = result.pathname
  pathname.input |> should.equal("/users/42")
  dict.get(pathname.groups, "id") |> should.equal(Ok("42"))
}

pub fn exec_no_match_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/users/:id")
    |> url_pattern.build
  url_pattern.exec(pattern, "https://example.com/posts/42")
  |> should.be_error
}

pub fn exec_with_base_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/items/:name")
    |> url_pattern.build
  let assert Ok(result) =
    url_pattern.exec_with_base(pattern, "/items/widget", "https://example.com")
  let pathname = result.pathname
  dict.get(pathname.groups, "name") |> should.equal(Ok("widget"))
}

pub fn exec_with_base_no_match_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/items/:name")
    |> url_pattern.build
  url_pattern.exec_with_base(pattern, "/other/path", "https://example.com")
  |> should.be_error
}

pub fn exec_with_base_invalid_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/items/:name")
    |> url_pattern.build
  url_pattern.exec_with_base(pattern, "/items/widget", "not a url")
  |> should.be_error
}

pub fn properties_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_protocol("https")
    |> url_pattern.with_hostname("example.com")
    |> url_pattern.with_port("8080")
    |> url_pattern.with_pathname("/path")
    |> url_pattern.with_search("q=1")
    |> url_pattern.with_hash("section")
    |> url_pattern.build
  url_pattern.protocol(pattern) |> should.equal("https")
  url_pattern.hostname(pattern) |> should.equal("example.com")
  url_pattern.port(pattern) |> should.equal("8080")
  url_pattern.pathname(pattern) |> should.equal("/path")
  url_pattern.search(pattern) |> should.equal("q=1")
  url_pattern.hash(pattern) |> should.equal("section")
}

pub fn username_password_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_username("user")
    |> url_pattern.with_password("pass")
    |> url_pattern.build
  url_pattern.username(pattern) |> should.equal("user")
  url_pattern.password(pattern) |> should.equal("pass")
}

pub fn has_reg_exp_groups_test() {
  let assert Ok(simple_pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/foo")
    |> url_pattern.build
  url_pattern.has_reg_exp_groups(simple_pattern) |> should.be_false
}

pub fn match_fields_test() {
  let assert Ok(pattern) =
    url_pattern.new()
    |> url_pattern.with_pathname("/users/:id")
    |> url_pattern.build
  let assert Ok(result) =
    url_pattern.exec(pattern, "https://example.com/users/99")
  let url_pattern.Match(
    protocol:,
    username:,
    password:,
    hostname:,
    port:,
    pathname:,
    search:,
    hash:,
  ) = result
  protocol.input |> should.equal("https")
  username.input |> should.equal("")
  password.input |> should.equal("")
  hostname.input |> should.equal("example.com")
  port.input |> should.equal("")
  pathname.input |> should.equal("/users/99")
  search.input |> should.equal("")
  hash.input |> should.equal("")
}
