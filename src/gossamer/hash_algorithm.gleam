/// Cryptographic hash algorithms supported by `subtle_crypto`.
///
/// Unrecognized or non-standard algorithms use `Other(String)`.
///
pub type HashAlgorithm {
  Sha1
  Sha256
  Sha384
  Sha512
  Other(String)
}
