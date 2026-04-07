import gossamer/url_pattern_init.{type URLPatternInit}
import gossamer/url_pattern_result.{type URLPatternResult}

@external(javascript, "./url_pattern.type.ts", "URLPattern$")
pub type URLPattern

@external(javascript, "./url_pattern.ffi.mjs", "new_")
pub fn new(init: List(URLPatternInit)) -> Result(URLPattern, String)

@external(javascript, "./url_pattern.ffi.mjs", "new_from_string")
pub fn new_from_string(pattern: String) -> Result(URLPattern, String)

@external(javascript, "./url_pattern.ffi.mjs", "new_from_string_with_base")
pub fn new_from_string_with_base(
  pattern: String,
  base_url: String,
) -> Result(URLPattern, String)

@external(javascript, "./url_pattern.ffi.mjs", "test_")
pub fn test_(pattern: URLPattern, input: String) -> Bool

@external(javascript, "./url_pattern.ffi.mjs", "test_with_base")
pub fn test_with_base(
  pattern: URLPattern,
  input: String,
  base_url: String,
) -> Bool

@external(javascript, "./url_pattern.ffi.mjs", "exec")
pub fn exec(pattern: URLPattern, input: String) -> Result(URLPatternResult, Nil)

@external(javascript, "./url_pattern.ffi.mjs", "exec_with_base")
pub fn exec_with_base(
  pattern: URLPattern,
  input: String,
  base_url: String,
) -> Result(URLPatternResult, Nil)

@external(javascript, "./url_pattern.ffi.mjs", "protocol")
pub fn protocol(pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "username")
pub fn username(pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "password")
pub fn password(pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "hostname")
pub fn hostname(pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "port")
pub fn port(pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "pathname")
pub fn pathname(pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "search")
pub fn search(pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "hash")
pub fn hash(pattern: URLPattern) -> String

@external(javascript, "./url_pattern.ffi.mjs", "has_reg_exp_groups")
pub fn has_reg_exp_groups(pattern: URLPattern) -> Bool
