import gleam/dict.{type Dict}
import gossamer/js_error.{type JsError}

/// Opaque handle to the underlying JS `URLPattern`.
///
@external(javascript, "./url_pattern_ref.type.ts", "URLPatternRef$")
@internal
pub type URLPatternRef

/// A pattern for matching URLs, with support for wildcards and named
/// groups. Useful for routing and URL matching.
///
/// See [URLPattern](https://developer.mozilla.org/en-US/docs/Web/API/URLPattern) on MDN.
///
pub type URLPattern {
  URLPattern(
    protocol: String,
    username: String,
    password: String,
    hostname: String,
    port: String,
    pathname: String,
    search: String,
    hash: String,
    has_reg_exp_groups: Bool,
    /// Internal handle to the underlying JS `URLPattern`.
    ref: URLPatternRef,
  )
}

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
pub fn new(init: List(URLPatternInit)) -> Result(URLPattern, JsError)

/// Creates a `URLPattern` from a single pattern string. Returns an error
/// if the pattern is malformed.
///
@external(javascript, "./url_pattern.ffi.mjs", "from_string")
pub fn from_string(pattern: String) -> Result(URLPattern, JsError)

/// Creates a `URLPattern` from a pattern string resolved against a base
/// URL. Returns an error if the pattern is malformed or the base URL is
/// invalid.
///
@external(javascript, "./url_pattern.ffi.mjs", "from_string_with_base")
pub fn from_string_with_base(
  pattern: String,
  relative_to base_url: String,
) -> Result(URLPattern, JsError)

@external(javascript, "./url_pattern.ffi.mjs", "test_")
pub fn test_(pattern: URLPattern, against input: String) -> Bool

/// Like `test`, but resolves `input` against `base_url` before matching.
/// Returns `False` if `base_url` is not a valid URL (the match algorithm
/// returns null rather than throwing).
///
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
/// Returns `Error(Nil)` if there is no match or `base_url` is not a valid
/// URL.
///
@external(javascript, "./url_pattern.ffi.mjs", "exec_with_base")
pub fn exec_with_base(
  pattern: URLPattern,
  against input: String,
  relative_to base_url: String,
) -> Result(URLPatternResult, Nil)
