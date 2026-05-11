import gleam/dynamic.{type Dynamic}

/// Errors raised by `fetch_extra` and the `blob`/`file` body-reading
/// bindings. Mirrors `gleam_fetch.FetchError`'s NetworkError /
/// UnableToReadBody / InvalidJsonBody variants and adds `Aborted` for
/// bindings that accept an `AbortSignal`.
///
pub type FetchError {
  /// A network error occurred (lost connection, server timeout, DNS
  /// failure, etc.). The `message` payload carries the underlying
  /// runtime detail.
  NetworkError(message: String)

  /// The body has already been consumed and can't be re-read. Body
  /// streams are single-pass per spec.
  UnableToReadBody

  /// The body was expected to be valid JSON but parsing failed.
  InvalidJsonBody

  /// The operation was aborted via an `AbortSignal`. The `reason`
  /// payload carries whatever value was passed to `abort(reason)` — or
  /// an `AbortError` `DOMException` if `abort()` was called with no
  /// argument.
  Aborted(reason: Dynamic)
}
