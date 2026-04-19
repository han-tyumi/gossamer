import gossamer/blob.{type Blob}
import gossamer/url_search_params.{type URLSearchParams}

/// A parsed URL. Mutable — setters like `set_hostname` modify the URL in
/// place and return it for chaining.
///
/// See [URL](https://developer.mozilla.org/en-US/docs/Web/API/URL) on MDN.
///
@external(javascript, "./url.type.ts", "URL$")
pub type URL

/// Parses `url` into a `URL`. Returns an error if the string is not a
/// valid absolute URL.
///
@external(javascript, "./url.ffi.mjs", "new_")
pub fn new(url: String) -> Result(URL, String)

/// Parses `url`, resolving relative URLs against `base`. Returns an error
/// if the resolved URL is invalid.
///
@external(javascript, "./url.ffi.mjs", "new_with_base")
pub fn new_with_base(
  url: String,
  relative_to base: String,
) -> Result(URL, String)

/// Like `new`, but returns `Error(Nil)` instead of an error message when
/// the URL is invalid. Useful when the failure reason isn't needed.
///
@external(javascript, "./url.ffi.mjs", "parse")
pub fn parse(url: String) -> Result(URL, Nil)

/// Like `new_with_base`, but returns `Error(Nil)` instead of an error
/// message when the URL is invalid.
///
@external(javascript, "./url.ffi.mjs", "parse_with_base")
pub fn parse_with_base(
  url: String,
  relative_to base: String,
) -> Result(URL, Nil)

@external(javascript, "./url.ffi.mjs", "can_parse")
pub fn can_parse(url: String) -> Bool

@external(javascript, "./url.ffi.mjs", "can_parse_with_base")
pub fn can_parse_with_base(url: String, relative_to base: String) -> Bool

@external(javascript, "./url.ffi.mjs", "hash")
pub fn hash(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_hash")
pub fn set_hash(of url: URL, to hash: String) -> URL

@external(javascript, "./url.ffi.mjs", "host")
pub fn host(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_host")
pub fn set_host(of url: URL, to host: String) -> URL

@external(javascript, "./url.ffi.mjs", "hostname")
pub fn hostname(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_hostname")
pub fn set_hostname(of url: URL, to hostname: String) -> URL

@external(javascript, "./url.ffi.mjs", "href")
pub fn href(of url: URL) -> String

/// Sets the full URL string, reparsing it. Returns an error if the new
/// `href` is not a valid URL.
///
@external(javascript, "./url.ffi.mjs", "set_href")
pub fn set_href(of url: URL, to href: String) -> Result(URL, String)

@external(javascript, "./url.ffi.mjs", "origin")
pub fn origin(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "password")
pub fn password(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_password")
pub fn set_password(of url: URL, to password: String) -> URL

@external(javascript, "./url.ffi.mjs", "pathname")
pub fn pathname(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_pathname")
pub fn set_pathname(of url: URL, to pathname: String) -> URL

@external(javascript, "./url.ffi.mjs", "port")
pub fn port(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_port")
pub fn set_port(of url: URL, to port: String) -> URL

@external(javascript, "./url.ffi.mjs", "protocol")
pub fn protocol(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_protocol")
pub fn set_protocol(of url: URL, to protocol: String) -> URL

@external(javascript, "./url.ffi.mjs", "search")
pub fn search(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_search")
pub fn set_search(of url: URL, to search: String) -> URL

@external(javascript, "./url.ffi.mjs", "search_params")
pub fn search_params(of url: URL) -> URLSearchParams

@external(javascript, "./url.ffi.mjs", "username")
pub fn username(of url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_username")
pub fn set_username(of url: URL, to username: String) -> URL

@external(javascript, "./url.ffi.mjs", "to_string")
pub fn to_string(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "to_json")
pub fn to_json(url: URL) -> String

/// Creates a string containing a URL representing the given blob. The URL
/// lifetime is tied to the document or worker that created it.
///
@external(javascript, "./url.ffi.mjs", "create_object_url")
pub fn create_object_url(blob: Blob) -> String

/// Revokes an object URL previously created with `create_object_url`. Call
/// this to release the reference once the URL is no longer needed.
///
@external(javascript, "./url.ffi.mjs", "revoke_object_url")
pub fn revoke_object_url(url: String) -> Nil
