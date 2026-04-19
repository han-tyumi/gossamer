import gossamer/ec_algorithm.{type EcAlgorithm}
import gossamer/hash_algorithm.{type HashAlgorithm}
import gossamer/named_curve.{type NamedCurve}
import gossamer/rsa_algorithm.{type RsaAlgorithm}

/// Algorithm parameters for `subtle_crypto.import_key` and
/// `import_key_jwk`.
///
pub type ImportAlgorithm {
  HmacImport(hash: HashAlgorithm)
  RsaHashedImport(name: RsaAlgorithm, hash: HashAlgorithm)
  EcImport(name: EcAlgorithm, named_curve: NamedCurve)
  Other(String)
}
