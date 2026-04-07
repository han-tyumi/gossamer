import gossamer/headers.{type Headers}

pub type ResponseInit {
  Headers(Headers)
  Status(Int)
  StatusText(String)
}
