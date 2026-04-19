/// Elliptic curve algorithms supported by `subtle_crypto`.
///
pub type EcAlgorithm {
  Ecdh
  Ecdsa
  Other(String)
}
