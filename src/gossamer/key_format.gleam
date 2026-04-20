/// The serialization format of a key imported or exported via
/// `subtle_crypto`.
///
/// Unrecognized values use `Other(String)`.
///
pub type KeyFormat {
  Pkcs8
  Raw
  Spki
  Other(String)
}
