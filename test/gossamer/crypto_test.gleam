import gossamer/array_buffer
import gossamer/crypto
import gossamer/crypto_key
import gossamer/crypto_key_pair
import gossamer/key_format
import gossamer/key_type
import gossamer/key_usage
import gossamer/promise
import gossamer/subtle_crypto
import gossamer/subtle_crypto/encrypt_algorithm
import gossamer/subtle_crypto/import_algorithm
import gossamer/subtle_crypto/key_gen_algorithm
import gossamer/subtle_crypto/key_pair_gen_algorithm
import gossamer/subtle_crypto/sign_algorithm
import gossamer/uint8_array
import gleam/string
import gleeunit/should

pub fn get_random_values_test() {
  let array = uint8_array.from_length(16)
  let result = crypto.get_random_values(array)
  should.equal(uint8_array.byte_length(result), 16)
}

pub fn random_uuid_test() {
  let uuid = crypto.random_uuid()
  should.equal(string.length(uuid), 36)
}

pub fn digest_test() {
  let data = uint8_array.from_list([1, 2, 3])
  use result <- promise.then(subtle_crypto.digest("SHA-256", data))
  should.equal(array_buffer.byte_length(result), 32)
  promise.resolve(Nil)
}

pub fn generate_key_and_encrypt_decrypt_test() {
  use key <- promise.then(
    subtle_crypto.generate_key(key_gen_algorithm.Aes("AES-GCM", 256), True, [
      key_usage.Encrypt,
      key_usage.Decrypt,
    ]),
  )

  should.equal(crypto_key.extractable(key), True)
  should.equal(crypto_key.type_(key), key_type.Secret)

  let iv = crypto.get_random_values(uint8_array.from_length(12))
  let plaintext = uint8_array.from_list([72, 101, 108, 108, 111])

  use ciphertext <- promise.then(subtle_crypto.encrypt(
    encrypt_algorithm.AesGcm(iv),
    key,
    plaintext,
  ))
  should.be_true(array_buffer.byte_length(ciphertext) > 0)

  use decrypted <- promise.then(subtle_crypto.decrypt(
    encrypt_algorithm.AesGcm(iv),
    key,
    uint8_array.from_buffer(ciphertext),
  ))
  let result = uint8_array.from_buffer(decrypted)
  should.equal(uint8_array.byte_length(result), 5)
  promise.resolve(Nil)
}

pub fn generate_key_pair_sign_verify_test() {
  use pair <- promise.then(
    subtle_crypto.generate_key_pair(
      key_pair_gen_algorithm.Ec("ECDSA", "P-256"),
      True,
      [key_usage.Sign, key_usage.Verify],
    ),
  )

  let crypto_key_pair.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(crypto_key.type_(public_key), key_type.Public)
  should.equal(crypto_key.type_(private_key), key_type.Private)

  let data = uint8_array.from_list([1, 2, 3])

  use signature <- promise.then(subtle_crypto.sign(
    sign_algorithm.Ecdsa("SHA-256"),
    private_key,
    data,
  ))
  should.be_true(array_buffer.byte_length(signature) > 0)

  use verified <- promise.then(subtle_crypto.verify(
    sign_algorithm.Ecdsa("SHA-256"),
    public_key,
    uint8_array.from_buffer(signature),
    data,
  ))
  should.be_true(verified)
  promise.resolve(Nil)
}

pub fn import_export_key_test() {
  let raw_key = crypto.get_random_values(uint8_array.from_length(16))

  use key <- promise.then(
    subtle_crypto.import_key(
      key_format.Raw,
      raw_key,
      import_algorithm.Name("AES-GCM"),
      True,
      [key_usage.Encrypt, key_usage.Decrypt],
    ),
  )

  should.equal(crypto_key.extractable(key), True)

  use exported <- promise.then(subtle_crypto.export_key(key_format.Raw, key))
  should.equal(array_buffer.byte_length(exported), 16)
  promise.resolve(Nil)
}
