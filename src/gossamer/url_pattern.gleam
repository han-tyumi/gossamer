import gleam/dict.{type Dict}

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

@external(javascript, "./url_pattern.ffi.mjs", "new_")
pub fn new(init: List(URLPatternInit)) -> Result(URLPattern, String)

@external(javascript, "./url_pattern.ffi.mjs", "new_from_string")
pub fn new_from_string(pattern: String) -> Result(URLPattern, String)

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

@external(javascript, "./url_pattern.ffi.mjs", "exec")
pub fn exec(
  pattern: URLPattern,
  against input: String,
) -> Result(URLPatternResult, Nil)

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
