/// A Unicode normalization form used by `string.normalize_with`. NFC and
/// NFD preserve equivalence; NFKC and NFKD also apply compatibility
/// decomposition.
///
pub type NormalizationForm {
  Nfc
  Nfd
  Nfkc
  Nfkd
}
