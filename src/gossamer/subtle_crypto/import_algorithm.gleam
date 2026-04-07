pub type ImportAlgorithm {
  Name(String)
  HmacImport(hash: String)
  RsaHashedImport(name: String, hash: String)
  EcImport(name: String, named_curve: String)
}
