import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/option.{None}
import gossamer/url

pub fn main() -> Promise(Nil) {
  // gossamer/url parses per the WHATWG URL spec and returns a canonical
  // gleam/uri.Uri: the host is lowercased, the default port is dropped, and
  // the `..` path segment is resolved.
  let assert Ok(canonical) =
    url.parse("HTTPS://Example.COM:443/api/../v1?q=gleam", relative_to: None)
  io.println("host: " <> option.unwrap(canonical.host, ""))
  io.println("path: " <> canonical.path)

  use _ <- promise.map(promise.resolve(Nil))
  io.println("done")
}
