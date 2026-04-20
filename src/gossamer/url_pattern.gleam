import gleam/dict.{type Dict}

/// A pattern for matching URLs, with support for wildcards and named
/// groups. Useful for routing and URL matching.
///
/// See [URLPattern](https://developer.mozilla.org/en-US/docs/Web/API/URLPattern) on MDN.
///
@external(javascript, "./url_pattern.type.ts", "URLPattern$")
pub type URLPattern

pub type URLPatternInit {
  Protocol(String)
  Username(String)
  Password(String)
  Hostname(String)
  Port(String)
  Pathname(String)
  Search(String)
  Hash(String)
  BaseURL(String)
}

pub type URLPatternComponentResult {
  URLPatternComponentResult(input: String, groups: Dict(String, String))
}

pub type URLPatternResult {
  URLPatternResult(
    protocol: URLPatternComponentResult,
    username: URLPatternComponentResult,
    password: URLPatternComponentResult,
    hostname: URLPatternComponentResult,
    port: URLPatternComponentResult,
    pathname: URLPatternComponentResult,
    search: URLPatternComponentResult,
    hash: URLPatternComponentResult,
  )
}

/// Creates a `URLPattern` from per-component patterns. Returns an error
/// if any pattern is malformed.
///
@external(javascript, "./url_pattern.ffi.mjs", "new_")
pub fn new(init: List(URLPatternInit)) -> Result(URLPattern, String)

/// Creates a `URLPattern` from a single pattern string. Returns an error
/// if the pattern is malformed.
///
@external(javascript, "./url_pattern.ffi.mjs", "new_from_string")
pub fn new_from_string(pattern: String) -> Result(URLPattern, String)

/// Creates a `URLPattern` from a pattern string resolved against a base
/// URL. Returns an error if the pattern is malformed or the base URL is
/// invalid.
///
@external(javascript, "./url_pattern.ffi.mjs", "new_from_string_with_base")
pub fn new_from_string_with_base(
  pattern: String,
  relative_to base_url: String,
) -> Result(URLPattern, String)

@external(javascript, "./url_pattern.ffi.mjs", "test_")
pub fn test_(pattern: URLPattern, against input: String) -> Bool

@external(javascript, "./url_pattern.ffi.mjs", "test_with_base")
pub fn test_with_base(
  pattern: URLPattern,
  against input: String,
  relative_to base_url: String,
) -> Bool

/// Matches `input` against the pattern and returns the captured
/// components, or `Error(Nil)` if there is no match.
///
@external(javascript, "./url_pattern.ffi.mjs", "exec")
pub fn exec(
  pattern: URLPattern,
  against input: String,
) -> Result(URLPatternResult, Nil)

/// Like `exec`, but resolves `input` against `base_url` before matching.
///
@external(javascript, "./url_pattern.ffi.mjs", "exec_with_base")
pub fn exec_with_base(
  pattern: URLPattern,
  against input: String,
  relative_to base_url: String,
) -> Result(URLPatternResult, Nil)

@external(javascript, "./url_pattern.ffi.mjs", "protocol")
pub fn protocol(of pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "username")
pub fn username(of pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "password")
pub fn password(of pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "hostname")
pub fn hostname(of pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "port")
pub fn port(of pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "pathname")
pub fn pathname(of pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "search")
pub fn search(of pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "hash")
pub fn hash(of pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "has_reg_exp_groups")
pub fn has_reg_exp_groups(pattern: URLPattern) -> Bool
