import gossamer/abort_signal.{type AbortSignal}
import gossamer/headers.{type Headers}

pub type RequestInit {
  Method(String)
  Headers(Headers)
  Body(String)
  Redirect(String)
  Signal(AbortSignal)
  Referrer(String)
  Keepalive(Bool)
  Integrity(String)
}
