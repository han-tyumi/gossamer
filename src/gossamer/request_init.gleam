import gossamer/abort_signal.{type AbortSignal}
import gossamer/headers.{type Headers}
import gossamer/http_method.{type HttpMethod}
import gossamer/referrer_policy.{type ReferrerPolicy}
import gossamer/request_cache.{type RequestCache}
import gossamer/request_credentials.{type RequestCredentials}
import gossamer/request_mode.{type RequestMode}
import gossamer/request_redirect.{type RequestRedirect}

pub type RequestInit {
  Method(HttpMethod)
  Headers(Headers)
  Body(String)
  Cache(RequestCache)
  Credentials(RequestCredentials)
  Integrity(String)
  Keepalive(Bool)
  Mode(RequestMode)
  Redirect(RequestRedirect)
  Referrer(String)
  ReferrerPolicy(ReferrerPolicy)
  Signal(AbortSignal)
}
