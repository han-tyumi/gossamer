pub type KeyGenAlgorithm {
  Aes(name: String, length: Int)
  HmacGen(hash: String)
}
