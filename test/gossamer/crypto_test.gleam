import gleam/bit_array
import gleam/list
import gleam/option
import gleam/string
import gleeunit/should
import gossamer/aes_algorithm
import gossamer/buffer/uint8_array
import gossamer/crypto
import gossamer/crypto_key
import gossamer/ec_algorithm
import gossamer/hash_algorithm
import gossamer/key_format
import gossamer/key_type
import gossamer/key_usage
import gossamer/named_curve
import gossamer/promise
import gossamer/rsa_algorithm
import gossamer/subtle_crypto
import gossamer/subtle_crypto/derive_algorithm
import gossamer/subtle_crypto/derived_key_type
import gossamer/subtle_crypto/encrypt_algorithm
import gossamer/subtle_crypto/import_algorithm
import gossamer/subtle_crypto/key_gen_algorithm
import gossamer/subtle_crypto/key_pair_gen_algorithm
import gossamer/subtle_crypto/sign_algorithm
import gossamer/subtle_crypto/wrap_algorithm

pub fn get_random_values_test() {
  let assert Ok(array) = uint8_array.from_length(16)
  let assert Ok(result) = crypto.get_random_values(array)
  should.equal(uint8_array.byte_length(result), 16)
}

pub fn random_uuid_test() {
  let uuid = crypto.random_uuid()
  should.equal(string.length(uuid), 36)
}

pub fn digest_test() {
  let data = <<1, 2, 3>>
  use result <- promise.then(subtle_crypto.digest(hash_algorithm.Sha256, data))
  let assert Ok(hash) = result
  should.equal(bit_array.byte_size(hash), 32)
  promise.resolve(Nil)
}

pub fn digest_unaligned_test() {
  let unaligned = <<1:size(7)>>
  use result <- promise.then(subtle_crypto.digest(
    hash_algorithm.Sha256,
    unaligned,
  ))
  should.be_error(result)
  promise.resolve(Nil)
}

pub fn generate_key_and_encrypt_decrypt_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [
        key_usage.Encrypt,
        key_usage.Decrypt,
      ],
    ),
  )
  let assert Ok(key) = result

  should.equal(crypto_key.is_extractable(key), True)
  should.equal(crypto_key.type_(key), key_type.Secret)

  let assert Ok(iv_source) = uint8_array.from_length(12)
  let assert Ok(iv_raw) = crypto.get_random_values(iv_source)
  let iv = uint8_array.to_bit_array(iv_raw)
  let plaintext = <<"Hello":utf8>>

  use result <- promise.then(subtle_crypto.encrypt(
    encrypt_algorithm.AesGcm(iv),
    key,
    plaintext,
  ))
  let assert Ok(ciphertext) = result
  should.be_true(bit_array.byte_size(ciphertext) > 0)

  use result <- promise.then(subtle_crypto.decrypt(
    encrypt_algorithm.AesGcm(iv),
    key,
    ciphertext,
  ))
  let assert Ok(decrypted) = result
  should.equal(bit_array.byte_size(decrypted), 5)
  promise.resolve(Nil)
}

pub fn generate_key_pair_sign_verify_test() {
  use result <- promise.then(
    subtle_crypto.generate_key_pair(
      key_pair_gen_algorithm.Ec(ec_algorithm.Ecdsa, named_curve.P256),
      True,
      [key_usage.Sign, key_usage.Verify],
    ),
  )
  let assert Ok(pair) = result

  let subtle_crypto.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(crypto_key.type_(public_key), key_type.Public)
  should.equal(crypto_key.type_(private_key), key_type.Private)

  let data = <<1, 2, 3>>

  use result <- promise.then(subtle_crypto.sign(
    sign_algorithm.Ecdsa(hash_algorithm.Sha256),
    private_key,
    data,
  ))
  let assert Ok(signature) = result
  should.be_true(bit_array.byte_size(signature) > 0)

  use result <- promise.then(subtle_crypto.verify(
    sign_algorithm.Ecdsa(hash_algorithm.Sha256),
    public_key,
    signature,
    data,
  ))
  let assert Ok(verified) = result
  should.be_true(verified)
  promise.resolve(Nil)
}

pub fn generate_rsa_key_pair_test() {
  use result <- promise.then(
    subtle_crypto.generate_key_pair(
      key_pair_gen_algorithm.Rsa(
        rsa_algorithm.RsassaPkcs1V15,
        2048,
        <<1, 0, 1>>,
        hash_algorithm.Sha256,
      ),
      True,
      [key_usage.Sign, key_usage.Verify],
    ),
  )
  let assert Ok(pair) = result
  let subtle_crypto.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(crypto_key.type_(public_key), key_type.Public)
  should.equal(crypto_key.type_(private_key), key_type.Private)
  let algo = crypto_key.algorithm(private_key)
  let assert crypto_key.Rsa(name:, modulus_length:, ..) = algo
  should.equal(name, rsa_algorithm.RsassaPkcs1V15)
  should.equal(modulus_length, 2048)
  promise.resolve(Nil)
}

pub fn import_export_key_test() {
  let assert Ok(raw_key_source) = uint8_array.from_length(16)
  let assert Ok(raw_key_uint8) = crypto.get_random_values(raw_key_source)
  let raw_key = uint8_array.to_bit_array(raw_key_uint8)

  use result <- promise.then(
    subtle_crypto.import_key(
      key_format.Raw,
      raw_key,
      import_algorithm.Other("AES-GCM"),
      True,
      [key_usage.Encrypt, key_usage.Decrypt],
    ),
  )
  let assert Ok(key) = result

  should.equal(crypto_key.is_extractable(key), True)

  use result <- promise.then(subtle_crypto.export_key(key_format.Raw, key))
  let assert Ok(exported) = result
  should.equal(bit_array.byte_size(exported), 16)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [
        key_usage.Encrypt,
      ],
    ),
  )
  let assert Ok(key) = result
  let algo = crypto_key.algorithm(key)
  should.equal(algo, crypto_key.Aes(aes_algorithm.AesGcm, 256))
  promise.resolve(Nil)
}

pub fn crypto_key_usages_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [
        key_usage.Encrypt,
        key_usage.Decrypt,
      ],
    ),
  )
  let assert Ok(key) = result
  let usages = crypto_key.usages(key)
  should.be_true(list.contains(usages, key_usage.Encrypt))
  should.be_true(list.contains(usages, key_usage.Decrypt))
  should.equal(list.length(usages), 2)
  promise.resolve(Nil)
}

pub fn export_key_jwk_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [
        key_usage.Encrypt,
        key_usage.Decrypt,
      ],
    ),
  )
  let assert Ok(key) = result

  use result <- promise.then(subtle_crypto.export_key_jwk(key))
  let assert Ok(jwk) = result
  jwk.kty |> should.equal(option.Some("oct"))
  jwk.alg |> should.equal(option.Some("A256GCM"))
  jwk.ext |> should.equal(option.Some(True))
  option.is_some(jwk.k) |> should.be_true
  option.is_some(jwk.key_ops) |> should.be_true
  promise.resolve(Nil)
}

pub fn import_key_jwk_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [
        key_usage.Encrypt,
        key_usage.Decrypt,
      ],
    ),
  )
  let assert Ok(key) = result

  use result <- promise.then(subtle_crypto.export_key_jwk(key))
  let assert Ok(jwk) = result

  use result <- promise.then(
    subtle_crypto.import_key_jwk(jwk, import_algorithm.Other("AES-GCM"), True, [
      key_usage.Encrypt,
      key_usage.Decrypt,
    ]),
  )
  let assert Ok(imported) = result
  crypto_key.type_(imported) |> should.equal(key_type.Secret)
  promise.resolve(Nil)
}

pub fn derive_bits_test() {
  let password = <<"pass":utf8>>
  let assert Ok(salt_source) = uint8_array.from_length(16)
  let assert Ok(salt_uint8) = crypto.get_random_values(salt_source)
  let salt = uint8_array.to_bit_array(salt_uint8)

  use result <- promise.then(
    subtle_crypto.import_key(
      key_format.Raw,
      password,
      import_algorithm.Other("PBKDF2"),
      False,
      [key_usage.DeriveBits],
    ),
  )
  let assert Ok(base_key) = result

  use result <- promise.then(subtle_crypto.derive_bits(
    derive_algorithm.Pbkdf2(hash_algorithm.Sha256, 100_000, salt),
    base_key,
    256,
  ))
  let assert Ok(bits) = result
  bit_array.byte_size(bits) |> should.equal(32)
  promise.resolve(Nil)
}

pub fn derive_key_test() {
  let password = <<"pass":utf8>>
  let assert Ok(salt_source) = uint8_array.from_length(16)
  let assert Ok(salt_uint8) = crypto.get_random_values(salt_source)
  let salt = uint8_array.to_bit_array(salt_uint8)

  use result <- promise.then(
    subtle_crypto.import_key(
      key_format.Raw,
      password,
      import_algorithm.Other("PBKDF2"),
      False,
      [key_usage.DeriveKey],
    ),
  )
  let assert Ok(base_key) = result

  use result <- promise.then(
    subtle_crypto.derive_key(
      derive_algorithm.Pbkdf2(hash_algorithm.Sha256, 100_000, salt),
      base_key,
      derived_key_type.AesDerived(aes_algorithm.AesGcm, 256),
      True,
      [key_usage.Encrypt, key_usage.Decrypt],
    ),
  )
  let assert Ok(derived) = result
  crypto_key.type_(derived) |> should.equal(key_type.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_test() {
  // Generate a wrapping key (AES-KW).
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesKw, 256),
      True,
      [
        key_usage.WrapKey,
        key_usage.UnwrapKey,
      ],
    ),
  )
  let assert Ok(wrapping_key) = result

  // Generate a key to be wrapped.
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [
        key_usage.Encrypt,
      ],
    ),
  )
  let assert Ok(key_to_wrap) = result

  use result <- promise.then(subtle_crypto.wrap_key(
    key_format.Raw,
    key_to_wrap,
    wrapping_key,
    wrap_algorithm.Other("AES-KW"),
  ))
  let assert Ok(wrapped) = result
  should.be_true(bit_array.byte_size(wrapped) > 0)

  use result <- promise.then(
    subtle_crypto.unwrap_key(
      key_format.Raw,
      wrapped,
      wrapping_key,
      wrap_algorithm.Other("AES-KW"),
      import_algorithm.Other("AES-GCM"),
      True,
      [key_usage.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  crypto_key.type_(unwrapped) |> should.equal(key_type.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_jwk_test() {
  // Generate a wrapping key (AES-KW).
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesKw, 256),
      True,
      [
        key_usage.WrapKey,
        key_usage.UnwrapKey,
      ],
    ),
  )
  let assert Ok(wrapping_key) = result

  // Generate a key to be wrapped.
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [
        key_usage.Encrypt,
      ],
    ),
  )
  let assert Ok(key_to_wrap) = result

  use result <- promise.then(subtle_crypto.wrap_key_jwk(
    key_to_wrap,
    wrapping_key,
    wrap_algorithm.Other("AES-KW"),
  ))
  let assert Ok(wrapped_jwk) = result
  should.be_true(bit_array.byte_size(wrapped_jwk) > 0)

  use result <- promise.then(
    subtle_crypto.unwrap_key_jwk(
      wrapped_jwk,
      wrapping_key,
      wrap_algorithm.Other("AES-KW"),
      import_algorithm.Other("AES-GCM"),
      True,
      [key_usage.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  crypto_key.type_(unwrapped) |> should.equal(key_type.Secret)
  promise.resolve(Nil)
}
