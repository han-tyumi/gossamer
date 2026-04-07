import gossamer/url_search_params.{type URLSearchParams}

@external(javascript, "./url.type.ts", "URL$")
pub type URL

/// Returns an error if the URL is invalid.
///
@external(javascript, "./url.ffi.mjs", "new_")
pub fn new(url: String) -> Result(URL, String)

/// Returns an error if the URL is invalid.
///
@external(javascript, "./url.ffi.mjs", "new_with_base")
pub fn new_with_base(url: String, base: String) -> Result(URL, String)

@external(javascript, "./url.ffi.mjs", "parse")
pub fn parse(url: String) -> Result(URL, Nil)

@external(javascript, "./url.ffi.mjs", "parse_with_base")
pub fn parse_with_base(url: String, base: String) -> Result(URL, Nil)

@external(javascript, "./url.ffi.mjs", "can_parse")
pub fn can_parse(url: String) -> Bool

@external(javascript, "./url.ffi.mjs", "can_parse_with_base")
pub fn can_parse_with_base(url: String, base: String) -> Bool

@external(javascript, "./url.ffi.mjs", "hash")
pub fn hash(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_hash")
pub fn set_hash(url: URL, hash: String) -> URL

@external(javascript, "./url.ffi.mjs", "host")
pub fn host(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_host")
pub fn set_host(url: URL, host: String) -> URL

@external(javascript, "./url.ffi.mjs", "hostname")
pub fn hostname(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_hostname")
pub fn set_hostname(url: URL, hostname: String) -> URL

@external(javascript, "./url.ffi.mjs", "href")
pub fn href(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_href")
pub fn set_href(url: URL, href: String) -> URL

@external(javascript, "./url.ffi.mjs", "origin")
pub fn origin(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "password")
pub fn password(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_password")
pub fn set_password(url: URL, password: String) -> URL

@external(javascript, "./url.ffi.mjs", "pathname")
pub fn pathname(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_pathname")
pub fn set_pathname(url: URL, pathname: String) -> URL

@external(javascript, "./url.ffi.mjs", "port")
pub fn port(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_port")
pub fn set_port(url: URL, port: String) -> URL

@external(javascript, "./url.ffi.mjs", "protocol")
pub fn protocol(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_protocol")
pub fn set_protocol(url: URL, protocol: String) -> URL

@external(javascript, "./url.ffi.mjs", "search")
pub fn search(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_search")
pub fn set_search(url: URL, search: String) -> URL

@external(javascript, "./url.ffi.mjs", "search_params")
pub fn search_params(url: URL) -> URLSearchParams

@external(javascript, "./url.ffi.mjs", "username")
pub fn username(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "set_username")
pub fn set_username(url: URL, username: String) -> URL

@external(javascript, "./url.ffi.mjs", "to_string")
pub fn to_string(url: URL) -> String

@external(javascript, "./url.ffi.mjs", "to_json")
pub fn to_json(url: URL) -> String
