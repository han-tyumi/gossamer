/// Whether a `CryptoKey` is public, private, or secret (symmetric).
///
/// Unrecognized values use `Other(String)`.
///
pub type KeyType {
  Private
  Public
  Secret
  Other(String)
}
