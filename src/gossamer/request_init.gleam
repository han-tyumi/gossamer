import gossamer/abort_signal.{type AbortSignal}
import gossamer/headers.{type Headers}
import gossamer/request_redirect.{type RequestRedirect}

pub type RequestInit {
  Method(String)
  Headers(Headers)
  Body(String)
  Redirect(RequestRedirect)
  Signal(AbortSignal)
  Referrer(String)
  Keepalive(Bool)
  Integrity(String)
}
