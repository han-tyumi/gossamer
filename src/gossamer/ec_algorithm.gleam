/// Elliptic curve algorithms supported by `subtle_crypto`.
///
/// Unrecognized or non-standard algorithms use `Other(String)`.
///
pub type EcAlgorithm {
  Ecdh
  Ecdsa
  Other(String)
}
