/// An allowed use for a `CryptoKey`. A key can only be used with operations
/// matching one of its declared usages.
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
