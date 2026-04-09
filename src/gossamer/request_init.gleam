import gossamer/abort_signal.{type AbortSignal}
import gossamer/headers.{type Headers}
import gossamer/http_method.{type HttpMethod}
import gossamer/request_redirect.{type RequestRedirect}

pub type RequestInit {
  Method(HttpMethod)
  Headers(Headers)
  Body(String)
  Redirect(RequestRedirect)
  Signal(AbortSignal)
  Referrer(String)
  Keepalive(Bool)
  Integrity(String)
}
