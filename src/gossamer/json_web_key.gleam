import gleam/list
import gleam/option.{type Option, None, Some}
import gossamer/key_usage.{type KeyUsage}

/// Represents a JSON Web Key (JWK) as defined by RFC 7517. Used with
/// `subtle_crypto.import_key_jwk` and `subtle_crypto.export_key_jwk`.
///
pub type JsonWebKey {
  JsonWebKey(
    kty: Option(String),
    use_: Option(String),
    key_ops: Option(List(KeyUsage)),
    alg: Option(String),
    ext: Option(Bool),
    crv: Option(String),
    x: Option(String),
    y: Option(String),
    d: Option(String),
    n: Option(String),
    e: Option(String),
    p: Option(String),
    q: Option(String),
    dp: Option(String),
    dq: Option(String),
    qi: Option(String),
    k: Option(String),
  )
}

/// A single JWK field, used with `from_fields` for ergonomic construction.
///
pub type JsonWebKeyField {
  Kty(String)
  Use(String)
  KeyOps(List(KeyUsage))
  Alg(String)
  Ext(Bool)
  Crv(String)
  X(String)
  Y(String)
  D(String)
  N(String)
  E(String)
  P(String)
  Q(String)
  Dp(String)
  Dq(String)
  Qi(String)
  K(String)
}

/// Creates a `JsonWebKey` with all fields set to `None`.
///
pub fn new() -> JsonWebKey {
  JsonWebKey(
    kty: None,
    use_: None,
    key_ops: None,
    alg: None,
    ext: None,
    crv: None,
    x: None,
    y: None,
    d: None,
    n: None,
    e: None,
    p: None,
    q: None,
    dp: None,
    dq: None,
    qi: None,
    k: None,
  )
}

/// Creates a `JsonWebKey` from a list of fields.
///
/// ## Examples
///
/// ```gleam
/// json_web_key.from_fields([Kty("oct"), Alg("A256GCM"), K(key_data)])
/// ```
///
pub fn from_fields(fields: List(JsonWebKeyField)) -> JsonWebKey {
  list.fold(over: fields, from: new(), with: fn(jwk, field) {
    case field {
      Kty(value) -> JsonWebKey(..jwk, kty: Some(value))
      Use(value) -> JsonWebKey(..jwk, use_: Some(value))
      KeyOps(value) -> JsonWebKey(..jwk, key_ops: Some(value))
      Alg(value) -> JsonWebKey(..jwk, alg: Some(value))
      Ext(value) -> JsonWebKey(..jwk, ext: Some(value))
      Crv(value) -> JsonWebKey(..jwk, crv: Some(value))
      X(value) -> JsonWebKey(..jwk, x: Some(value))
      Y(value) -> JsonWebKey(..jwk, y: Some(value))
      D(value) -> JsonWebKey(..jwk, d: Some(value))
      N(value) -> JsonWebKey(..jwk, n: Some(value))
      E(value) -> JsonWebKey(..jwk, e: Some(value))
      P(value) -> JsonWebKey(..jwk, p: Some(value))
      Q(value) -> JsonWebKey(..jwk, q: Some(value))
      Dp(value) -> JsonWebKey(..jwk, dp: Some(value))
      Dq(value) -> JsonWebKey(..jwk, dq: Some(value))
      Qi(value) -> JsonWebKey(..jwk, qi: Some(value))
      K(value) -> JsonWebKey(..jwk, k: Some(value))
    }
  })
}
