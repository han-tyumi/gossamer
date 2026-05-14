//// WHATWG URL operations.
////
//// `gleam/uri.parse` follows RFC 3986 and accepts URI references
//// without a scheme (`/path`, `foo`). `gossamer/url` exposes the
//// stricter WHATWG URL parser for cases where rejecting relative
//// inputs matters (network endpoints, configuration validation).
//// Parsed results are returned as `gleam/uri.Uri`.

import gleam/uri.{type Uri}

/// Parses `url` as an absolute URL per the WHATWG URL spec. Returns
/// an error if `url` is not a valid absolute URL.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(uri) = url.parse("https://example.org/path?q=1")
/// ```
///
@external(javascript, "./url.ffi.mjs", "parse")
pub fn parse(url: String) -> Result(Uri, Nil)

/// Returns `True` if `url` is a valid absolute URL per the WHATWG URL
/// spec. Equivalent to JavaScript's `URL.canParse`.
///
@external(javascript, "./url.ffi.mjs", "is_valid")
pub fn is_valid(url: String) -> Bool
