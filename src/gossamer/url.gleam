//// WHATWG URL parsing.
////
//// `gleam/uri.parse` parses per RFC 3986: it accepts relative references
//// (`/path`, `foo`) and normalizes nothing beyond lowercasing the scheme.
//// `gossamer/url` exposes the WHATWG URL parser, which requires an
//// absolute URL (or a relative one given a base) and returns it in
//// canonical form: the host lowercased, default ports dropped, `.` and
//// `..` path segments resolved,
//// components percent-encoded, and internationalized hostnames converted
//// to punycode. Results are returned as `gleam/uri.Uri`.
////
//// Reach for `gleam/uri` to parse an input faithfully; reach for
//// `gossamer/url` for a validated, canonical URL, useful for comparison,
//// deduplication, or use as a request endpoint.

import gleam/option.{type Option}
import gleam/uri.{type Uri}

/// Parses `url` as an absolute URL per the WHATWG URL spec and returns it
/// in canonical form. Pass `Some(base)` to resolve a relative `url`
/// against a base URL. Returns an error if `url` is not a valid URL, or is
/// relative with no base.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(uri) =
///   url.parse("HTTPS://Example.COM/a/../b", relative_to: None)
/// // uri is the canonical https://example.com/b
/// ```
///
@external(javascript, "./url.ffi.mjs", "parse")
pub fn parse(url: String, relative_to base: Option(String)) -> Result(Uri, Nil)

/// Returns `True` if `url` is a valid URL per the WHATWG URL spec. Pass
/// `Some(base)` to check a relative `url` against a base. Equivalent to
/// JavaScript's `URL.canParse`.
///
@external(javascript, "./url.ffi.mjs", "is_valid")
pub fn is_valid(url: String, relative_to base: Option(String)) -> Bool
