//// Patterns for matching URLs, with wildcards, named groups, and
//// regular-expression groups. Useful for routing and request
//// dispatching. Parse a single
//// [URL Pattern Syntax](https://urlpattern.spec.whatwg.org/#pattern-syntax)
//// string with [`from_string`](#from_string), or build a per-component
//// pattern via the [`Builder`](#Builder). Match with
//// [`matches`](#matches) (boolean) or [`exec`](#exec) (captures).

import gleam/dict.{type Dict}
import gleam/option.{type Option, None, Some}

/// A pattern for matching URLs, with support for wildcards and named
/// groups. Useful for routing and URL matching.
///
/// See [URLPattern](https://developer.mozilla.org/en-US/docs/Web/API/URLPattern) on MDN.
///
@external(javascript, "./url_pattern.type.ts", "UrlPattern$")
pub type UrlPattern

/// The per-component configuration for a [`UrlPattern`](#UrlPattern).
/// Unset components match any value.
///
pub opaque type Builder {
  Builder(
    protocol: Option(String),
    username: Option(String),
    password: Option(String),
    hostname: Option(String),
    port: Option(String),
    pathname: Option(String),
    search: Option(String),
    hash: Option(String),
    base_url: Option(String),
  )
}

/// One captured URL component from a successful match: the input string
/// that matched, and any named groups extracted from it.
///
pub type ComponentMatch {
  ComponentMatch(input: String, groups: Dict(String, String))
}

/// The captured components from a successful URL match.
///
pub type Match {
  Match(
    protocol: ComponentMatch,
    username: ComponentMatch,
    password: ComponentMatch,
    hostname: ComponentMatch,
    port: ComponentMatch,
    pathname: ComponentMatch,
    search: ComponentMatch,
    hash: ComponentMatch,
  )
}

/// Creates an empty `Builder`. Every component is unset, meaning a
/// pattern built from this matches any URL.
///
pub fn new() -> Builder {
  Builder(
    protocol: None,
    username: None,
    password: None,
    hostname: None,
    port: None,
    pathname: None,
    search: None,
    hash: None,
    base_url: None,
  )
}

/// Sets the protocol pattern (the URL scheme, e.g. `"https"`).
///
pub fn with_protocol(builder: Builder, protocol: String) -> Builder {
  Builder(..builder, protocol: Some(protocol))
}

/// Sets the username pattern.
///
pub fn with_username(builder: Builder, username: String) -> Builder {
  Builder(..builder, username: Some(username))
}

/// Sets the password pattern.
///
pub fn with_password(builder: Builder, password: String) -> Builder {
  Builder(..builder, password: Some(password))
}

/// Sets the hostname pattern (e.g. `"example.com"`).
///
pub fn with_hostname(builder: Builder, hostname: String) -> Builder {
  Builder(..builder, hostname: Some(hostname))
}

/// Sets the port pattern (e.g. `"8080"`).
///
pub fn with_port(builder: Builder, port: String) -> Builder {
  Builder(..builder, port: Some(port))
}

/// Sets the pathname pattern (e.g. `"/users/:id"`).
///
pub fn with_pathname(builder: Builder, pathname: String) -> Builder {
  Builder(..builder, pathname: Some(pathname))
}

/// Sets the search pattern (the query string, without the leading `?`).
///
pub fn with_search(builder: Builder, search: String) -> Builder {
  Builder(..builder, search: Some(search))
}

/// Sets the hash pattern (the fragment, without the leading `#`).
///
pub fn with_hash(builder: Builder, hash: String) -> Builder {
  Builder(..builder, hash: Some(hash))
}

/// Sets the base URL used to resolve relative components.
///
pub fn with_base_url(builder: Builder, base_url: String) -> Builder {
  Builder(..builder, base_url: Some(base_url))
}

/// Constructs a `UrlPattern` from the configured `Builder`. Returns
/// an error if any component pattern is malformed.
///
pub fn build(builder: Builder) -> Result(UrlPattern, Nil) {
  do_build(
    builder.protocol,
    builder.username,
    builder.password,
    builder.hostname,
    builder.port,
    builder.pathname,
    builder.search,
    builder.hash,
    builder.base_url,
  )
}

@external(javascript, "./url_pattern.ffi.mjs", "build")
@internal
pub fn do_build(
  protocol: Option(String),
  username: Option(String),
  password: Option(String),
  hostname: Option(String),
  port: Option(String),
  pathname: Option(String),
  search: Option(String),
  hash: Option(String),
  base_url: Option(String),
) -> Result(UrlPattern, Nil)

/// Creates a `UrlPattern` from a pattern string. Pass `Some(base_url)`
/// to resolve relative components against a base URL. Returns an
/// error if the pattern is malformed or the base URL is invalid.
///
@external(javascript, "./url_pattern.ffi.mjs", "from_string")
pub fn from_string(
  pattern: String,
  relative_to base_url: Option(String),
) -> Result(UrlPattern, Nil)

/// Returns `True` if the pattern matches `input`. Pass `Some(base_url)`
/// to resolve `input` against a base URL before matching. Returns
/// `False` if `base_url` is `Some` but isn't a valid URL. Equivalent
/// to JavaScript's `pattern.test`.
///
@external(javascript, "./url_pattern.ffi.mjs", "matches")
pub fn matches(
  pattern: UrlPattern,
  against input: String,
  relative_to base_url: Option(String),
) -> Bool

/// Matches `input` against the pattern and returns the captured
/// components, or `Error(Nil)` if there's no match. Pass
/// `Some(base_url)` to resolve `input` against a base URL before
/// matching. Returns `Error(Nil)` if `base_url` is `Some` but isn't a
/// valid URL.
///
@external(javascript, "./url_pattern.ffi.mjs", "exec")
pub fn exec(
  pattern: UrlPattern,
  against input: String,
  relative_to base_url: Option(String),
) -> Result(Match, Nil)

/// The compiled protocol pattern.
///
@external(javascript, "./url_pattern.ffi.mjs", "protocol")
pub fn protocol(pattern: UrlPattern) -> String

/// The compiled username pattern.
///
@external(javascript, "./url_pattern.ffi.mjs", "username")
pub fn username(pattern: UrlPattern) -> String

/// The compiled password pattern.
///
@external(javascript, "./url_pattern.ffi.mjs", "password")
pub fn password(pattern: UrlPattern) -> String

/// The compiled hostname pattern.
///
@external(javascript, "./url_pattern.ffi.mjs", "hostname")
pub fn hostname(pattern: UrlPattern) -> String

/// The compiled port pattern.
///
@external(javascript, "./url_pattern.ffi.mjs", "port")
pub fn port(pattern: UrlPattern) -> String

/// The compiled pathname pattern.
///
@external(javascript, "./url_pattern.ffi.mjs", "pathname")
pub fn pathname(pattern: UrlPattern) -> String

/// The compiled search pattern.
///
@external(javascript, "./url_pattern.ffi.mjs", "search")
pub fn search(pattern: UrlPattern) -> String

/// The compiled hash pattern.
///
@external(javascript, "./url_pattern.ffi.mjs", "hash")
pub fn hash(pattern: UrlPattern) -> String

/// Whether any component pattern uses regular-expression groups.
///
@external(javascript, "./url_pattern.ffi.mjs", "has_reg_exp_groups")
pub fn has_reg_exp_groups(pattern: UrlPattern) -> Bool
