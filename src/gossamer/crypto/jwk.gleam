import gleam/option.{type Option, None, Some}
import gossamer/crypto.{type KeyUsage}

/// Represents a JSON Web Key (JWK) as defined by RFC 7517. Used with
/// `subtle.import_key_jwk` and `subtle.export_key_jwk`.
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

/// Sets the key type, e.g. `"EC"`, `"RSA"`, or `"oct"`.
///
pub fn set_kty(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, kty: Some(value))
}

/// Sets the intended use of the public key, e.g. `"sig"` or `"enc"`.
///
pub fn set_use(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, use_: Some(value))
}

/// Sets the operations the key is intended for.
///
pub fn set_key_ops(jwk: JsonWebKey, value: List(KeyUsage)) -> JsonWebKey {
  JsonWebKey(..jwk, key_ops: Some(value))
}

/// Sets the algorithm intended for use with the key.
///
pub fn set_alg(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, alg: Some(value))
}

/// Sets whether the key is extractable.
///
pub fn set_ext(jwk: JsonWebKey, value: Bool) -> JsonWebKey {
  JsonWebKey(..jwk, ext: Some(value))
}

/// Sets the elliptic curve name for an EC key.
///
pub fn set_crv(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, crv: Some(value))
}

/// Sets the x coordinate of an EC public key.
///
pub fn set_x(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, x: Some(value))
}

/// Sets the y coordinate of an EC public key.
///
pub fn set_y(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, y: Some(value))
}

/// Sets the private exponent (RSA) or private key value (EC, OKP).
///
pub fn set_d(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, d: Some(value))
}

/// Sets the modulus of an RSA public key.
///
pub fn set_n(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, n: Some(value))
}

/// Sets the public exponent of an RSA public key.
///
pub fn set_e(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, e: Some(value))
}

/// Sets the first prime factor of an RSA private key.
///
pub fn set_p(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, p: Some(value))
}

/// Sets the second prime factor of an RSA private key.
///
pub fn set_q(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, q: Some(value))
}

/// Sets the first factor CRT exponent of an RSA private key.
///
pub fn set_dp(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, dp: Some(value))
}

/// Sets the second factor CRT exponent of an RSA private key.
///
pub fn set_dq(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, dq: Some(value))
}

/// Sets the first CRT coefficient of an RSA private key.
///
pub fn set_qi(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, qi: Some(value))
}

/// Sets the symmetric key value for an `"oct"` key.
///
pub fn set_k(jwk: JsonWebKey, value: String) -> JsonWebKey {
  JsonWebKey(..jwk, k: Some(value))
}
