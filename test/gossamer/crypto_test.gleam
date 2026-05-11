import gleam/bit_array
import gleam/javascript/promise
import gleam/list
import gleam/option
import gleam/string
import gleeunit/should
import gossamer/crypto
import gossamer/crypto_key
import gossamer/subtle_crypto

pub fn random_bytes_test() {
  crypto.random_bytes(16) |> bit_array.byte_size |> should.equal(16)
}

pub fn random_bytes_negative_test() {
  crypto.random_bytes(-5) |> should.equal(<<>>)
}

pub fn random_bytes_quota_test() {
  // The Web Crypto getRandomValues quota is 65_536 bytes per call;
  // the binding chunks transparently for larger requests.
  crypto.random_bytes(100_000) |> bit_array.byte_size |> should.equal(100_000)
}

pub fn random_uuid_test() {
  let uuid = crypto.random_uuid()
  should.equal(string.length(uuid), 36)
}

pub fn digest_test() {
  let data = <<1, 2, 3>>
  use result <- promise.await(subtle_crypto.digest(crypto_key.Sha256, data))
  let assert Ok(hash) = result
  should.equal(bit_array.byte_size(hash), 32)
  promise.resolve(Nil)
}

pub fn digest_unaligned_test() {
  let unaligned = <<1:size(7)>>
  use result <- promise.await(subtle_crypto.digest(crypto_key.Sha256, unaligned))
  let assert Ok(hash) = result
  should.equal(bit_array.byte_size(hash), 32)
  promise.resolve(Nil)
}

pub fn generate_key_and_encrypt_decrypt_test() {
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesGcm, 256), True, [
      crypto_key.Encrypt,
      crypto_key.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  should.equal(crypto_key.is_extractable(key), True)
  should.equal(crypto_key.type_(key), crypto_key.Secret)

  let iv = crypto.random_bytes(12)
  let plaintext = <<"Hello":utf8>>

  use result <- promise.await(subtle_crypto.encrypt(
    subtle_crypto.AesGcm(iv),
    key,
    plaintext,
  ))
  let assert Ok(ciphertext) = result
  should.be_true(bit_array.byte_size(ciphertext) > 0)

  use result <- promise.await(subtle_crypto.decrypt(
    subtle_crypto.AesGcm(iv),
    key,
    ciphertext,
  ))
  let assert Ok(decrypted) = result
  should.equal(bit_array.byte_size(decrypted), 5)
  promise.resolve(Nil)
}

pub fn generate_key_pair_sign_verify_test() {
  use result <- promise.await(
    subtle_crypto.generate_key_pair(
      subtle_crypto.Ec(crypto_key.EcDsa, crypto_key.P256),
      True,
      [crypto_key.Sign, crypto_key.Verify],
    ),
  )
  let assert Ok(pair) = result

  let subtle_crypto.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(crypto_key.type_(public_key), crypto_key.Public)
  should.equal(crypto_key.type_(private_key), crypto_key.Private)

  let data = <<1, 2, 3>>

  use result <- promise.await(subtle_crypto.sign(
    subtle_crypto.EcDsa(crypto_key.Sha256),
    private_key,
    data,
  ))
  let assert Ok(signature) = result
  should.be_true(bit_array.byte_size(signature) > 0)

  use result <- promise.await(subtle_crypto.verify(
    subtle_crypto.EcDsa(crypto_key.Sha256),
    public_key,
    signature,
    data,
  ))
  let assert Ok(verified) = result
  should.be_true(verified)
  promise.resolve(Nil)
}

pub fn generate_rsa_key_pair_test() {
  use result <- promise.await(
    subtle_crypto.generate_key_pair(
      subtle_crypto.Rsa(
        crypto_key.RsaSsaPkcs1V15,
        2048,
        <<1, 0, 1>>,
        crypto_key.Sha256,
      ),
      True,
      [crypto_key.Sign, crypto_key.Verify],
    ),
  )
  let assert Ok(pair) = result
  let subtle_crypto.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(crypto_key.type_(public_key), crypto_key.Public)
  should.equal(crypto_key.type_(private_key), crypto_key.Private)
  let algo = crypto_key.algorithm(private_key)
  let assert crypto_key.Rsa(name:, modulus_length:, ..) = algo
  should.equal(name, crypto_key.RsaSsaPkcs1V15)
  should.equal(modulus_length, 2048)
  promise.resolve(Nil)
}

pub fn import_export_key_test() {
  let raw_key = crypto.random_bytes(16)

  use result <- promise.await(
    subtle_crypto.import_key(
      subtle_crypto.Raw,
      raw_key,
      subtle_crypto.ImportOther("AES-GCM"),
      True,
      [crypto_key.Encrypt, crypto_key.Decrypt],
    ),
  )
  let assert Ok(key) = result

  should.equal(crypto_key.is_extractable(key), True)

  use result <- promise.await(subtle_crypto.export_key(subtle_crypto.Raw, key))
  let assert Ok(exported) = result
  should.equal(bit_array.byte_size(exported), 16)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_test() {
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesGcm, 256), True, [
      crypto_key.Encrypt,
    ]),
  )
  let assert Ok(key) = result
  let algo = crypto_key.algorithm(key)
  should.equal(algo, crypto_key.Aes(crypto_key.AesGcm, 256))
  promise.resolve(Nil)
}

pub fn crypto_key_usages_test() {
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesGcm, 256), True, [
      crypto_key.Encrypt,
      crypto_key.Decrypt,
    ]),
  )
  let assert Ok(key) = result
  let usages = crypto_key.usages(key)
  should.be_true(list.contains(usages, crypto_key.Encrypt))
  should.be_true(list.contains(usages, crypto_key.Decrypt))
  should.equal(list.length(usages), 2)
  promise.resolve(Nil)
}

pub fn export_key_jwk_test() {
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesGcm, 256), True, [
      crypto_key.Encrypt,
      crypto_key.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  use result <- promise.await(subtle_crypto.export_key_jwk(key))
  let assert Ok(jwk) = result
  jwk.kty |> should.equal(option.Some("oct"))
  jwk.alg |> should.equal(option.Some("A256GCM"))
  jwk.ext |> should.equal(option.Some(True))
  option.is_some(jwk.k) |> should.be_true
  option.is_some(jwk.key_ops) |> should.be_true
  promise.resolve(Nil)
}

pub fn import_key_jwk_test() {
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesGcm, 256), True, [
      crypto_key.Encrypt,
      crypto_key.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  use result <- promise.await(subtle_crypto.export_key_jwk(key))
  let assert Ok(jwk) = result

  use result <- promise.await(
    subtle_crypto.import_key_jwk(
      jwk,
      subtle_crypto.ImportOther("AES-GCM"),
      True,
      [
        crypto_key.Encrypt,
        crypto_key.Decrypt,
      ],
    ),
  )
  let assert Ok(imported) = result
  crypto_key.type_(imported) |> should.equal(crypto_key.Secret)
  promise.resolve(Nil)
}

pub fn derive_bits_test() {
  let password = <<"pass":utf8>>
  let salt = crypto.random_bytes(16)

  use result <- promise.await(
    subtle_crypto.import_key(
      subtle_crypto.Raw,
      password,
      subtle_crypto.ImportOther("PBKDF2"),
      False,
      [crypto_key.DeriveBits],
    ),
  )
  let assert Ok(base_key) = result

  use result <- promise.await(subtle_crypto.derive_bits(
    subtle_crypto.Pbkdf2(crypto_key.Sha256, 100_000, salt),
    base_key,
    256,
  ))
  let assert Ok(bits) = result
  bit_array.byte_size(bits) |> should.equal(32)
  promise.resolve(Nil)
}

pub fn derive_key_test() {
  let password = <<"pass":utf8>>
  let salt = crypto.random_bytes(16)

  use result <- promise.await(
    subtle_crypto.import_key(
      subtle_crypto.Raw,
      password,
      subtle_crypto.ImportOther("PBKDF2"),
      False,
      [crypto_key.DeriveKey],
    ),
  )
  let assert Ok(base_key) = result

  use result <- promise.await(
    subtle_crypto.derive_key(
      subtle_crypto.Pbkdf2(crypto_key.Sha256, 100_000, salt),
      base_key,
      subtle_crypto.AesDerived(crypto_key.AesGcm, 256),
      True,
      [crypto_key.Encrypt, crypto_key.Decrypt],
    ),
  )
  let assert Ok(derived) = result
  crypto_key.type_(derived) |> should.equal(crypto_key.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_test() {
  // Generate a wrapping key (AES-KW).
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesKw, 256), True, [
      crypto_key.WrapKey,
      crypto_key.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  // Generate a key to be wrapped.
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesGcm, 256), True, [
      crypto_key.Encrypt,
    ]),
  )
  let assert Ok(key_to_wrap) = result

  use result <- promise.await(subtle_crypto.wrap_key(
    subtle_crypto.Raw,
    key_to_wrap,
    wrapping_key,
    subtle_crypto.WrapOther("AES-KW"),
  ))
  let assert Ok(wrapped) = result
  should.be_true(bit_array.byte_size(wrapped) > 0)

  use result <- promise.await(
    subtle_crypto.unwrap_key(
      subtle_crypto.Raw,
      wrapped,
      wrapping_key,
      subtle_crypto.WrapOther("AES-KW"),
      subtle_crypto.ImportOther("AES-GCM"),
      True,
      [crypto_key.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  crypto_key.type_(unwrapped) |> should.equal(crypto_key.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_jwk_test() {
  // Generate a wrapping key (AES-KW).
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesKw, 256), True, [
      crypto_key.WrapKey,
      crypto_key.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  // Generate a key to be wrapped.
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesGcm, 256), True, [
      crypto_key.Encrypt,
    ]),
  )
  let assert Ok(key_to_wrap) = result

  use result <- promise.await(subtle_crypto.wrap_key_jwk(
    key_to_wrap,
    wrapping_key,
    subtle_crypto.WrapOther("AES-KW"),
  ))
  let assert Ok(wrapped_jwk) = result
  should.be_true(bit_array.byte_size(wrapped_jwk) > 0)

  use result <- promise.await(
    subtle_crypto.unwrap_key_jwk(
      wrapped_jwk,
      wrapping_key,
      subtle_crypto.WrapOther("AES-KW"),
      subtle_crypto.ImportOther("AES-GCM"),
      True,
      [crypto_key.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  crypto_key.type_(unwrapped) |> should.equal(crypto_key.Secret)
  promise.resolve(Nil)
}

pub fn encrypt_key_usage_mismatch_test() {
  use result <- promise.await(
    subtle_crypto.generate_key(subtle_crypto.Aes(crypto_key.AesGcm, 256), True, [
      crypto_key.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  use encrypt_result <- promise.await(
    subtle_crypto.encrypt(subtle_crypto.AesGcm(crypto.random_bytes(12)), key, <<
      1,
      2,
      3,
    >>),
  )
  let assert Error(subtle_crypto.KeyUsageMismatch(crypto_key.Encrypt)) =
    encrypt_result
  promise.resolve(Nil)
}

pub fn export_key_not_extractable_test() {
  use result <- promise.await(
    subtle_crypto.generate_key(
      subtle_crypto.Aes(crypto_key.AesGcm, 256),
      False,
      [crypto_key.Encrypt],
    ),
  )
  let assert Ok(key) = result

  use export_result <- promise.await(subtle_crypto.export_key(
    subtle_crypto.Raw,
    key,
  ))
  let assert Error(subtle_crypto.KeyNotExtractable) = export_result
  promise.resolve(Nil)
}

pub fn digest_algorithm_not_supported_test() {
  use result <- promise.await(
    subtle_crypto.digest(crypto_key.HashOther("MADE-UP-HASH"), <<1, 2, 3>>),
  )
  let assert Error(subtle_crypto.AlgorithmNotSupported) = result
  promise.resolve(Nil)
}
