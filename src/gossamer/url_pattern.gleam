import gleam/dict.{type Dict}
import gleam/option.{type Option, None, Some}

/// A pattern for matching URLs, with support for wildcards and named
/// groups. Useful for routing and URL matching.
///
/// See [URLPattern](https://developer.mozilla.org/en-US/docs/Web/API/URLPattern) on MDN.
///
@external(javascript, "./url_pattern.type.ts", "UrlPattern$")
pub type UrlPattern

/// The per-component configuration for a `UrlPattern`. Construct with
/// `new`, refine with the `with_X` setters, then call `build`. Unset
/// components match any value.
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

/// Errors raised by `UrlPattern` construction.
pub type UrlPatternError {
  /// At least one component pattern (or the base URL) is malformed and
  /// can't be compiled.
  InvalidPattern
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
pub fn with_protocol(builder: Builder, value: String) -> Builder {
  Builder(..builder, protocol: Some(value))
}

/// Sets the username pattern.
///
pub fn with_username(builder: Builder, value: String) -> Builder {
  Builder(..builder, username: Some(value))
}

/// Sets the password pattern.
///
pub fn with_password(builder: Builder, value: String) -> Builder {
  Builder(..builder, password: Some(value))
}

/// Sets the hostname pattern (e.g. `"example.com"`).
///
pub fn with_hostname(builder: Builder, value: String) -> Builder {
  Builder(..builder, hostname: Some(value))
}

/// Sets the port pattern (e.g. `"8080"`).
///
pub fn with_port(builder: Builder, value: String) -> Builder {
  Builder(..builder, port: Some(value))
}

/// Sets the pathname pattern (e.g. `"/users/:id"`).
///
pub fn with_pathname(builder: Builder, value: String) -> Builder {
  Builder(..builder, pathname: Some(value))
}

/// Sets the search pattern (the query string, without the leading `?`).
///
pub fn with_search(builder: Builder, value: String) -> Builder {
  Builder(..builder, search: Some(value))
}

/// Sets the hash pattern (the fragment, without the leading `#`).
///
pub fn with_hash(builder: Builder, value: String) -> Builder {
  Builder(..builder, hash: Some(value))
}

/// Sets the base URL used to resolve relative components.
///
pub fn with_base_url(builder: Builder, value: String) -> Builder {
  Builder(..builder, base_url: Some(value))
}

/// Constructs a `UrlPattern` from the configured `Builder`. Returns
/// `InvalidPattern` if any component pattern is malformed.
///
pub fn build(builder: Builder) -> Result(UrlPattern, UrlPatternError) {
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
) -> Result(UrlPattern, UrlPatternError)

/// Creates a `UrlPattern` from a single pattern string. Returns
/// `InvalidPattern` if the pattern is malformed.
///
@external(javascript, "./url_pattern.ffi.mjs", "from_string")
pub fn from_string(pattern: String) -> Result(UrlPattern, UrlPatternError)

/// Creates a `UrlPattern` from a pattern string resolved against a base
/// URL. Returns `InvalidPattern` if the pattern is malformed or the
/// base URL is invalid.
///
@external(javascript, "./url_pattern.ffi.mjs", "from_string_with_base")
pub fn from_string_with_base(
  pattern: String,
  relative_to base_url: String,
) -> Result(UrlPattern, UrlPatternError)

/// Returns `True` if the pattern matches `input`.
///
@external(javascript, "./url_pattern.ffi.mjs", "test_")
pub fn test_(pattern: UrlPattern, against input: String) -> Bool

/// Like `test`, but resolves `input` against `base_url` before matching.
/// Returns `False` if `base_url` is not a valid URL (the match algorithm
/// returns null rather than throwing).
///
@external(javascript, "./url_pattern.ffi.mjs", "test_with_base")
pub fn test_with_base(
  pattern: UrlPattern,
  against input: String,
  relative_to base_url: String,
) -> Bool

/// Matches `input` against the pattern and returns the captured
/// components, or `Error(Nil)` if there is no match.
///
@external(javascript, "./url_pattern.ffi.mjs", "exec")
pub fn exec(pattern: UrlPattern, against input: String) -> Result(Match, Nil)

/// Like `exec`, but resolves `input` against `base_url` before matching.
/// Returns `Error(Nil)` if there is no match or `base_url` is not a valid
/// URL.
///
@external(javascript, "./url_pattern.ffi.mjs", "exec_with_base")
pub fn exec_with_base(
  pattern: UrlPattern,
  against input: String,
  relative_to base_url: String,
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
