pub type DerivedKeyType {
  Name(String)
  AesDerived(name: String, length: Int)
  HmacDerived(hash: String)
}
