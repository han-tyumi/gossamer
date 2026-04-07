import gleam/dict.{type Dict}

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
