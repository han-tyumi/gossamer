//// JSON Web Keys (JWK) as defined by
//// [RFC 7517](https://datatracker.ietf.org/doc/html/rfc7517). Passed to
//// [`subtle.import_key_jwk`](./subtle.html#import_key_jwk) and returned
//// by [`subtle.export_key_jwk`](./subtle.html#export_key_jwk).

import gleam/option.{type Option, None, Some}
import gossamer/crypto.{type KeyUsage}

/// A JSON Web Key (JWK), as defined by
/// [RFC 7517](https://datatracker.ietf.org/doc/html/rfc7517). Used with
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
pub fn set_kty(jwk: JsonWebKey, kty: String) -> JsonWebKey {
  JsonWebKey(..jwk, kty: Some(kty))
}

/// Sets the intended use of the public key, e.g. `"sig"` or `"enc"`.
///
pub fn set_use(jwk: JsonWebKey, use_: String) -> JsonWebKey {
  JsonWebKey(..jwk, use_: Some(use_))
}

/// Sets the operations the key is intended for.
///
pub fn set_key_ops(jwk: JsonWebKey, key_ops: List(KeyUsage)) -> JsonWebKey {
  JsonWebKey(..jwk, key_ops: Some(key_ops))
}

/// Sets the algorithm intended for use with the key.
///
pub fn set_alg(jwk: JsonWebKey, alg: String) -> JsonWebKey {
  JsonWebKey(..jwk, alg: Some(alg))
}

/// Sets whether the key is extractable.
///
pub fn set_ext(jwk: JsonWebKey, ext: Bool) -> JsonWebKey {
  JsonWebKey(..jwk, ext: Some(ext))
}

/// Sets the elliptic curve name for an EC key.
///
pub fn set_crv(jwk: JsonWebKey, crv: String) -> JsonWebKey {
  JsonWebKey(..jwk, crv: Some(crv))
}

/// Sets the x coordinate of an EC public key.
///
pub fn set_x(jwk: JsonWebKey, x: String) -> JsonWebKey {
  JsonWebKey(..jwk, x: Some(x))
}

/// Sets the y coordinate of an EC public key.
///
pub fn set_y(jwk: JsonWebKey, y: String) -> JsonWebKey {
  JsonWebKey(..jwk, y: Some(y))
}

/// Sets the private exponent (RSA) or private key value (EC, OKP).
///
pub fn set_d(jwk: JsonWebKey, d: String) -> JsonWebKey {
  JsonWebKey(..jwk, d: Some(d))
}

/// Sets the modulus of an RSA public key.
///
pub fn set_n(jwk: JsonWebKey, n: String) -> JsonWebKey {
  JsonWebKey(..jwk, n: Some(n))
}

/// Sets the public exponent of an RSA public key.
///
pub fn set_e(jwk: JsonWebKey, e: String) -> JsonWebKey {
  JsonWebKey(..jwk, e: Some(e))
}

/// Sets the first prime factor of an RSA private key.
///
pub fn set_p(jwk: JsonWebKey, p: String) -> JsonWebKey {
  JsonWebKey(..jwk, p: Some(p))
}

/// Sets the second prime factor of an RSA private key.
///
pub fn set_q(jwk: JsonWebKey, q: String) -> JsonWebKey {
  JsonWebKey(..jwk, q: Some(q))
}

/// Sets the first factor CRT exponent of an RSA private key.
///
pub fn set_dp(jwk: JsonWebKey, dp: String) -> JsonWebKey {
  JsonWebKey(..jwk, dp: Some(dp))
}

/// Sets the second factor CRT exponent of an RSA private key.
///
pub fn set_dq(jwk: JsonWebKey, dq: String) -> JsonWebKey {
  JsonWebKey(..jwk, dq: Some(dq))
}

/// Sets the first CRT coefficient of an RSA private key.
///
pub fn set_qi(jwk: JsonWebKey, qi: String) -> JsonWebKey {
  JsonWebKey(..jwk, qi: Some(qi))
}

/// Sets the symmetric key value for an `"oct"` key.
///
pub fn set_k(jwk: JsonWebKey, k: String) -> JsonWebKey {
  JsonWebKey(..jwk, k: Some(k))
}
