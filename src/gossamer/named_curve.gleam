/// A named elliptic curve used by ECDH and ECDSA operations in
/// `subtle_crypto`.
///
/// Unrecognized or non-standard curves use `Other(String)`.
///
pub type NamedCurve {
  P256
  P384
  P521
  Other(String)
}
