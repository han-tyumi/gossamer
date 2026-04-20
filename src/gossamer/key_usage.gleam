/// An allowed use for a `CryptoKey`. A key can only be used with operations
/// matching one of its declared usages.
///
/// Unrecognized values use `Other(String)`.
///
pub type KeyUsage {
  Decrypt
  DeriveBits
  DeriveKey
  Encrypt
  Sign
  UnwrapKey
  Verify
  WrapKey
  Other(String)
}
