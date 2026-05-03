import gleam/list
import gleam/option
import gleam/string
import gleeunit/should
import gossamer/aes_algorithm
import gossamer/array_buffer
import gossamer/crypto
import gossamer/crypto_key
import gossamer/data_view
import gossamer/ec_algorithm
import gossamer/hash_algorithm
import gossamer/int_typed_array
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
import gossamer/typed_array
import gossamer/uint8_array

pub fn get_random_values_test() {
  let assert Ok(array) = uint8_array.from_length(16)
  let assert Ok(int_typed_array.Uint8(result)) =
    crypto.get_random_values(int_typed_array.Uint8(array))
  should.equal(uint8_array.byte_length(result), 16)
}

pub fn random_uuid_test() {
  let uuid = crypto.random_uuid()
  should.equal(string.length(uuid), 36)
}

pub fn digest_test() {
  let data = typed_array.Uint8(uint8_array.from_list([1, 2, 3]))
  use result <- promise.then(subtle_crypto.digest(hash_algorithm.Sha256, data))
  let assert Ok(buffer) = result
  should.equal(array_buffer.byte_length(buffer), 32)
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
  let assert Ok(int_typed_array.Uint8(iv)) =
    crypto.get_random_values(int_typed_array.Uint8(iv_source))
  let plaintext =
    typed_array.Uint8(uint8_array.from_list([72, 101, 108, 108, 111]))

  use result <- promise.then(subtle_crypto.encrypt(
    encrypt_algorithm.AesGcm(typed_array.Uint8(iv)),
    key,
    plaintext,
  ))
  let assert Ok(ciphertext) = result
  should.be_true(array_buffer.byte_length(ciphertext) > 0)

  use result <- promise.then(subtle_crypto.decrypt(
    encrypt_algorithm.AesGcm(typed_array.Uint8(iv)),
    key,
    typed_array.Uint8(uint8_array.from_buffer(ciphertext)),
  ))
  let assert Ok(decrypted) = result
  let decrypted_bytes = uint8_array.from_buffer(decrypted)
  should.equal(uint8_array.byte_length(decrypted_bytes), 5)
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

  let data = typed_array.Uint8(uint8_array.from_list([1, 2, 3]))

  use result <- promise.then(subtle_crypto.sign(
    sign_algorithm.Ecdsa(hash_algorithm.Sha256),
    private_key,
    data,
  ))
  let assert Ok(signature) = result
  should.be_true(array_buffer.byte_length(signature) > 0)

  use result <- promise.then(subtle_crypto.verify(
    sign_algorithm.Ecdsa(hash_algorithm.Sha256),
    public_key,
    typed_array.Uint8(uint8_array.from_buffer(signature)),
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
        typed_array.Uint8(uint8_array.from_list([1, 0, 1])),
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
  let assert Ok(int_typed_array.Uint8(raw_key)) =
    crypto.get_random_values(int_typed_array.Uint8(raw_key_source))

  use result <- promise.then(
    subtle_crypto.import_key(
      key_format.Raw,
      typed_array.Uint8(raw_key),
      import_algorithm.Other("AES-GCM"),
      True,
      [key_usage.Encrypt, key_usage.Decrypt],
    ),
  )
  let assert Ok(key) = result

  should.equal(crypto_key.is_extractable(key), True)

  use result <- promise.then(subtle_crypto.export_key(key_format.Raw, key))
  let assert Ok(exported) = result
  should.equal(array_buffer.byte_length(exported), 16)
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
  let password = typed_array.Uint8(uint8_array.from_list([112, 97, 115, 115]))
  let assert Ok(salt_source) = uint8_array.from_length(16)
  let assert Ok(int_typed_array.Uint8(salt)) =
    crypto.get_random_values(int_typed_array.Uint8(salt_source))

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
    derive_algorithm.Pbkdf2(
      hash_algorithm.Sha256,
      100_000,
      typed_array.Uint8(salt),
    ),
    base_key,
    256,
  ))
  let assert Ok(bits) = result
  array_buffer.byte_length(bits) |> should.equal(32)
  promise.resolve(Nil)
}

pub fn derive_key_test() {
  let password = typed_array.Uint8(uint8_array.from_list([112, 97, 115, 115]))
  let assert Ok(salt_source) = uint8_array.from_length(16)
  let assert Ok(int_typed_array.Uint8(salt)) =
    crypto.get_random_values(int_typed_array.Uint8(salt_source))

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
      derive_algorithm.Pbkdf2(
        hash_algorithm.Sha256,
        100_000,
        typed_array.Uint8(salt),
      ),
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
  should.be_true(array_buffer.byte_length(wrapped) > 0)

  use result <- promise.then(
    subtle_crypto.unwrap_key(
      key_format.Raw,
      typed_array.Uint8(uint8_array.from_buffer(wrapped)),
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

pub fn digest_buffer_test() {
  let bytes = uint8_array.from_list([1, 2, 3])
  let buffer = uint8_array.buffer(bytes)
  use result <- promise.then(subtle_crypto.digest_buffer(
    hash_algorithm.Sha256,
    buffer,
  ))
  let assert Ok(buf) = result
  array_buffer.byte_length(buf) |> should.equal(32)
  promise.resolve(Nil)
}

pub fn encrypt_decrypt_buffer_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [key_usage.Encrypt, key_usage.Decrypt],
    ),
  )
  let assert Ok(key) = result

  let assert Ok(iv_source) = uint8_array.from_length(12)
  let assert Ok(int_typed_array.Uint8(iv)) =
    crypto.get_random_values(int_typed_array.Uint8(iv_source))

  let plaintext_bytes = uint8_array.from_list([72, 105])
  let plaintext = uint8_array.buffer(plaintext_bytes)

  use result <- promise.then(subtle_crypto.encrypt_buffer(
    encrypt_algorithm.AesGcm(typed_array.Uint8(iv)),
    key,
    plaintext,
  ))
  let assert Ok(ciphertext) = result
  should.be_true(array_buffer.byte_length(ciphertext) > 0)

  use result <- promise.then(subtle_crypto.decrypt_buffer(
    encrypt_algorithm.AesGcm(typed_array.Uint8(iv)),
    key,
    ciphertext,
  ))
  let assert Ok(decrypted) = result
  let decrypted_bytes = uint8_array.from_buffer(decrypted)
  uint8_array.byte_length(decrypted_bytes) |> should.equal(2)
  promise.resolve(Nil)
}

pub fn sign_verify_buffer_test() {
  use result <- promise.then(
    subtle_crypto.generate_key_pair(
      key_pair_gen_algorithm.Ec(ec_algorithm.Ecdsa, named_curve.P256),
      True,
      [key_usage.Sign, key_usage.Verify],
    ),
  )
  let assert Ok(pair) = result
  let subtle_crypto.CryptoKeyPair(public_key:, private_key:) = pair

  let data_bytes = uint8_array.from_list([1, 2, 3])
  let data = uint8_array.buffer(data_bytes)

  use result <- promise.then(subtle_crypto.sign_buffer(
    sign_algorithm.Ecdsa(hash_algorithm.Sha256),
    private_key,
    data,
  ))
  let assert Ok(signature) = result
  should.be_true(array_buffer.byte_length(signature) > 0)

  use result <- promise.then(subtle_crypto.verify_buffer(
    sign_algorithm.Ecdsa(hash_algorithm.Sha256),
    public_key,
    signature,
    data,
  ))
  let assert Ok(verified) = result
  should.be_true(verified)
  promise.resolve(Nil)
}

pub fn import_key_buffer_test() {
  let assert Ok(raw_source) = uint8_array.from_length(16)
  let assert Ok(int_typed_array.Uint8(raw)) =
    crypto.get_random_values(int_typed_array.Uint8(raw_source))
  let raw_buffer = uint8_array.buffer(raw)

  use result <- promise.then(
    subtle_crypto.import_key_buffer(
      key_format.Raw,
      raw_buffer,
      import_algorithm.Other("AES-GCM"),
      True,
      [key_usage.Encrypt, key_usage.Decrypt],
    ),
  )
  let assert Ok(key) = result
  crypto_key.is_extractable(key) |> should.be_true
  promise.resolve(Nil)
}

pub fn unwrap_key_buffer_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesKw, 256),
      True,
      [key_usage.WrapKey, key_usage.UnwrapKey],
    ),
  )
  let assert Ok(wrapping_key) = result

  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [key_usage.Encrypt],
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

  use result <- promise.then(
    subtle_crypto.unwrap_key_buffer(
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

pub fn unwrap_key_jwk_buffer_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesKw, 256),
      True,
      [key_usage.WrapKey, key_usage.UnwrapKey],
    ),
  )
  let assert Ok(wrapping_key) = result

  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [key_usage.Encrypt],
    ),
  )
  let assert Ok(key_to_wrap) = result

  use result <- promise.then(subtle_crypto.wrap_key_jwk(
    key_to_wrap,
    wrapping_key,
    wrap_algorithm.Other("AES-KW"),
  ))
  let assert Ok(wrapped_jwk) = result

  use result <- promise.then(
    subtle_crypto.unwrap_key_jwk_buffer(
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

pub fn digest_data_view_test() {
  let bytes = uint8_array.from_list([1, 2, 3])
  let buffer = uint8_array.buffer(bytes)
  let assert Ok(view) = data_view.new(buffer)
  use result <- promise.then(subtle_crypto.digest_data_view(
    hash_algorithm.Sha256,
    view,
  ))
  let assert Ok(buf) = result
  array_buffer.byte_length(buf) |> should.equal(32)
  promise.resolve(Nil)
}

pub fn encrypt_decrypt_data_view_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [key_usage.Encrypt, key_usage.Decrypt],
    ),
  )
  let assert Ok(key) = result

  let assert Ok(iv_source) = uint8_array.from_length(12)
  let assert Ok(int_typed_array.Uint8(iv)) =
    crypto.get_random_values(int_typed_array.Uint8(iv_source))

  let plaintext_bytes = uint8_array.from_list([72, 105])
  let plaintext_buffer = uint8_array.buffer(plaintext_bytes)
  let assert Ok(plaintext) = data_view.new(plaintext_buffer)

  use result <- promise.then(subtle_crypto.encrypt_data_view(
    encrypt_algorithm.AesGcm(typed_array.Uint8(iv)),
    key,
    plaintext,
  ))
  let assert Ok(ciphertext) = result
  should.be_true(array_buffer.byte_length(ciphertext) > 0)

  let assert Ok(ciphertext_view) = data_view.new(ciphertext)
  use result <- promise.then(subtle_crypto.decrypt_data_view(
    encrypt_algorithm.AesGcm(typed_array.Uint8(iv)),
    key,
    ciphertext_view,
  ))
  let assert Ok(decrypted) = result
  let decrypted_bytes = uint8_array.from_buffer(decrypted)
  uint8_array.byte_length(decrypted_bytes) |> should.equal(2)
  promise.resolve(Nil)
}

pub fn sign_verify_data_view_test() {
  use result <- promise.then(
    subtle_crypto.generate_key_pair(
      key_pair_gen_algorithm.Ec(ec_algorithm.Ecdsa, named_curve.P256),
      True,
      [key_usage.Sign, key_usage.Verify],
    ),
  )
  let assert Ok(pair) = result
  let subtle_crypto.CryptoKeyPair(public_key:, private_key:) = pair

  let data_bytes = uint8_array.from_list([1, 2, 3])
  let data_buffer = uint8_array.buffer(data_bytes)
  let assert Ok(data) = data_view.new(data_buffer)

  use result <- promise.then(subtle_crypto.sign_data_view(
    sign_algorithm.Ecdsa(hash_algorithm.Sha256),
    private_key,
    data,
  ))
  let assert Ok(signature) = result
  should.be_true(array_buffer.byte_length(signature) > 0)

  let assert Ok(signature_view) = data_view.new(signature)
  use result <- promise.then(subtle_crypto.verify_data_view(
    sign_algorithm.Ecdsa(hash_algorithm.Sha256),
    public_key,
    signature_view,
    data,
  ))
  let assert Ok(verified) = result
  should.be_true(verified)
  promise.resolve(Nil)
}

pub fn import_key_data_view_test() {
  let assert Ok(raw_source) = uint8_array.from_length(16)
  let assert Ok(int_typed_array.Uint8(raw)) =
    crypto.get_random_values(int_typed_array.Uint8(raw_source))
  let raw_buffer = uint8_array.buffer(raw)
  let assert Ok(raw_view) = data_view.new(raw_buffer)

  use result <- promise.then(
    subtle_crypto.import_key_data_view(
      key_format.Raw,
      raw_view,
      import_algorithm.Other("AES-GCM"),
      True,
      [key_usage.Encrypt, key_usage.Decrypt],
    ),
  )
  let assert Ok(key) = result
  crypto_key.is_extractable(key) |> should.be_true
  promise.resolve(Nil)
}

pub fn unwrap_key_data_view_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesKw, 256),
      True,
      [key_usage.WrapKey, key_usage.UnwrapKey],
    ),
  )
  let assert Ok(wrapping_key) = result

  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [key_usage.Encrypt],
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
  let assert Ok(wrapped_view) = data_view.new(wrapped)

  use result <- promise.then(
    subtle_crypto.unwrap_key_data_view(
      key_format.Raw,
      wrapped_view,
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

pub fn unwrap_key_jwk_data_view_test() {
  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesKw, 256),
      True,
      [key_usage.WrapKey, key_usage.UnwrapKey],
    ),
  )
  let assert Ok(wrapping_key) = result

  use result <- promise.then(
    subtle_crypto.generate_key(
      key_gen_algorithm.Aes(aes_algorithm.AesGcm, 256),
      True,
      [key_usage.Encrypt],
    ),
  )
  let assert Ok(key_to_wrap) = result

  use result <- promise.then(subtle_crypto.wrap_key_jwk(
    key_to_wrap,
    wrapping_key,
    wrap_algorithm.Other("AES-KW"),
  ))
  let assert Ok(wrapped_jwk) = result
  let assert Ok(wrapped_view) = data_view.new(wrapped_jwk)

  use result <- promise.then(
    subtle_crypto.unwrap_key_jwk_data_view(
      wrapped_view,
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
  should.be_true(array_buffer.byte_length(wrapped_jwk) > 0)

  use result <- promise.then(
    subtle_crypto.unwrap_key_jwk(
      typed_array.Uint8(uint8_array.from_buffer(wrapped_jwk)),
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
