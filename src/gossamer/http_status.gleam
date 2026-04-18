/// An HTTP response status code.
///
/// Common codes from [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html)
/// are named explicitly. Uncommon or non-standard codes use `Other(Int)`.
///
pub type HttpStatus {

  // 1xx Informational
  /// 100
  Continue
  /// 101
  SwitchingProtocols

  // 2xx Success
  /// 200
  Ok
  /// 201
  Created
  /// 202
  Accepted
  /// 204
  NoContent
  /// 206
  PartialContent

  // 3xx Redirection
  /// 301
  MovedPermanently
  /// 302
  Found
  /// 303
  SeeOther
  /// 304
  NotModified
  /// 307
  TemporaryRedirect
  /// 308
  PermanentRedirect

  // 4xx Client Error
  /// 400
  BadRequest
  /// 401
  Unauthorized
  /// 403
  Forbidden
  /// 404
  NotFound
  /// 405
  MethodNotAllowed
  /// 409
  Conflict
  /// 410
  Gone
  /// 413
  PayloadTooLarge
  /// 415
  UnsupportedMediaType
  /// 418
  ImATeapot
  /// 422
  UnprocessableContent
  /// 429
  TooManyRequests

  // 5xx Server Error
  /// 500
  InternalServerError
  /// 501
  NotImplemented
  /// 502
  BadGateway
  /// 503
  ServiceUnavailable
  /// 504
  GatewayTimeout

  Other(Int)
}
