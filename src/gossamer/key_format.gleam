/// The serialization format of a key imported or exported via
/// `subtle_crypto`.
///
pub type KeyFormat {
  Pkcs8
  Raw
  Spki
  Other(String)
}
