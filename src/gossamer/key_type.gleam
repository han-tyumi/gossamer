/// Whether a `CryptoKey` is public, private, or secret (symmetric).
///
pub type KeyType {
  Private
  Public
  Secret
  Other(String)
}
