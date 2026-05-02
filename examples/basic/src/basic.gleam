import gleam/io
import gleam/option.{Some}
import gossamer/headers
import gossamer/promise.{type Promise}
import gossamer/url

pub fn main() -> Promise(Nil) {
  let assert Ok(parsed) = url.new("https://example.com/api?q=gleam")
  io.println("host: " <> url.host(parsed))

  let hs = headers.new()
  let assert Ok(hs) =
    headers.append(to: hs, name: "content-type", value: "application/json")
  let assert Ok(Some(ct)) = headers.get(from: hs, name: "content-type")
  io.println("content-type: " <> ct)

  use _ <- promise.then(promise.resolve(Nil))
  io.println("done")
}
