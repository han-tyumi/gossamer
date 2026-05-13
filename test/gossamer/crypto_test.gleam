import gleam/bit_array
import gleam/javascript/promise
import gleam/list
import gleam/option
import gleam/string
import gleeunit/should
import gossamer/crypto
import gossamer/crypto/key
import gossamer/crypto/subtle
import runtime

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
  use result <- promise.await(subtle.digest(crypto.Sha256, data))
  let assert Ok(hash) = result
  should.equal(bit_array.byte_size(hash), 32)
  promise.resolve(Nil)
}

pub fn digest_unaligned_test() {
  let unaligned = <<1:size(7)>>
  use result <- promise.await(subtle.digest(crypto.Sha256, unaligned))
  let assert Ok(hash) = result
  should.equal(bit_array.byte_size(hash), 32)
  promise.resolve(Nil)
}

pub fn generate_key_and_encrypt_decrypt_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  should.equal(key.is_extractable(key), True)
  should.equal(key.kind(key), crypto.Secret)

  let iv = crypto.random_bytes(12)
  let plaintext = <<"Hello":utf8>>

  use result <- promise.await(subtle.encrypt(
    subtle.EncryptAesGcm(iv),
    key,
    plaintext,
  ))
  let assert Ok(ciphertext) = result
  should.be_true(bit_array.byte_size(ciphertext) > 0)

  use result <- promise.await(subtle.decrypt(
    subtle.EncryptAesGcm(iv),
    key,
    ciphertext,
  ))
  let assert Ok(decrypted) = result
  should.equal(bit_array.byte_size(decrypted), 5)
  promise.resolve(Nil)
}

pub fn generate_key_pair_sign_verify_test() {
  use result <- promise.await(
    subtle.generate_key_pair(
      subtle.KeyPairGenEc(crypto.EcDsa, crypto.P256),
      True,
      [
        crypto.Sign,
        crypto.Verify,
      ],
    ),
  )
  let assert Ok(pair) = result

  let subtle.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(key.kind(public_key), crypto.Public)
  should.equal(key.kind(private_key), crypto.Private)

  let data = <<1, 2, 3>>

  use result <- promise.await(subtle.sign(
    subtle.SignEcDsa(crypto.Sha256),
    private_key,
    data,
  ))
  let assert Ok(signature) = result
  should.be_true(bit_array.byte_size(signature) > 0)

  use result <- promise.await(subtle.verify(
    subtle.SignEcDsa(crypto.Sha256),
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
    subtle.generate_key_pair(
      subtle.KeyPairGenRsa(
        crypto.RsaSsaPkcs1V15,
        2048,
        <<1, 0, 1>>,
        crypto.Sha256,
      ),
      True,
      [crypto.Sign, crypto.Verify],
    ),
  )
  let assert Ok(pair) = result
  let subtle.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(key.kind(public_key), crypto.Public)
  should.equal(key.kind(private_key), crypto.Private)
  let algo = key.algorithm(private_key)
  let assert crypto.Rsa(name:, modulus_length:, ..) = algo
  should.equal(name, crypto.RsaSsaPkcs1V15)
  should.equal(modulus_length, 2048)
  promise.resolve(Nil)
}

pub fn import_export_key_test() {
  let raw_key = crypto.random_bytes(16)

  use result <- promise.await(
    subtle.import_key(
      subtle.Raw,
      raw_key,
      subtle.ImportAes(crypto.AesGcm),
      True,
      [
        crypto.Encrypt,
        crypto.Decrypt,
      ],
    ),
  )
  let assert Ok(key) = result

  should.equal(key.is_extractable(key), True)

  use result <- promise.await(subtle.export_key(subtle.Raw, key))
  let assert Ok(exported) = result
  should.equal(bit_array.byte_size(exported), 16)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key) = result
  let algo = key.algorithm(key)
  should.equal(algo, crypto.Aes(crypto.AesGcm, 256))
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_ed25519_test() {
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenEd25519, True, [
      crypto.Sign,
      crypto.Verify,
    ]),
  )
  let assert Ok(pair) = result
  key.algorithm(pair.public_key) |> should.equal(crypto.Ed25519)
  key.algorithm(pair.private_key) |> should.equal(crypto.Ed25519)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_x25519_test() {
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenX25519, True, [crypto.DeriveBits]),
  )
  let assert Ok(pair) = result
  key.algorithm(pair.public_key) |> should.equal(crypto.X25519)
  key.algorithm(pair.private_key) |> should.equal(crypto.X25519)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_hkdf_test() {
  use result <- promise.await(
    subtle.import_key(
      subtle.Raw,
      crypto.random_bytes(32),
      subtle.ImportHkdf,
      False,
      [crypto.DeriveBits],
    ),
  )
  let assert Ok(base_key) = result
  key.algorithm(base_key) |> should.equal(crypto.Hkdf)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_pbkdf2_test() {
  use result <- promise.await(
    subtle.import_key(subtle.Raw, <<"pass":utf8>>, subtle.ImportPbkdf2, False, [
      crypto.DeriveBits,
    ]),
  )
  let assert Ok(base_key) = result
  key.algorithm(base_key) |> should.equal(crypto.Pbkdf2)
  promise.resolve(Nil)
}

pub fn crypto_key_usages_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result
  let usages = key.usages(key)
  should.be_true(list.contains(usages, crypto.Encrypt))
  should.be_true(list.contains(usages, crypto.Decrypt))
  should.equal(list.length(usages), 2)
  promise.resolve(Nil)
}

pub fn export_key_jwk_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  use result <- promise.await(subtle.export_key_jwk(key))
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
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  use result <- promise.await(subtle.export_key_jwk(key))
  let assert Ok(jwk) = result

  use result <- promise.await(
    subtle.import_key_jwk(jwk, subtle.ImportAes(crypto.AesGcm), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(imported) = result
  key.kind(imported) |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn derive_bits_test() {
  let password = <<"pass":utf8>>
  let salt = crypto.random_bytes(16)

  use result <- promise.await(
    subtle.import_key(subtle.Raw, password, subtle.ImportPbkdf2, False, [
      crypto.DeriveBits,
    ]),
  )
  let assert Ok(base_key) = result

  use result <- promise.await(subtle.derive_bits(
    subtle.DerivePbkdf2(crypto.Sha256, 100_000, salt),
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
    subtle.import_key(subtle.Raw, password, subtle.ImportPbkdf2, False, [
      crypto.DeriveKey,
    ]),
  )
  let assert Ok(base_key) = result

  use result <- promise.await(
    subtle.derive_key(
      subtle.DerivePbkdf2(crypto.Sha256, 100_000, salt),
      base_key,
      subtle.DerivedKeyAes(crypto.AesGcm, 256),
      True,
      [crypto.Encrypt, crypto.Decrypt],
    ),
  )
  let assert Ok(derived) = result
  key.kind(derived) |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_test() {
  // Generate a wrapping key (AES-KW).
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesKw, 256), True, [
      crypto.WrapKey,
      crypto.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  // Generate a key to be wrapped.
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key_to_wrap) = result

  use result <- promise.await(subtle.wrap_key(
    subtle.Raw,
    key_to_wrap,
    wrapping_key,
    subtle.WrapAesKw,
  ))
  let assert Ok(wrapped) = result
  should.be_true(bit_array.byte_size(wrapped) > 0)

  use result <- promise.await(
    subtle.unwrap_key(
      subtle.Raw,
      wrapped,
      wrapping_key,
      subtle.WrapAesKw,
      subtle.ImportAes(crypto.AesGcm),
      True,
      [crypto.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  key.kind(unwrapped) |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_jwk_test() {
  // Generate a wrapping key (AES-KW).
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesKw, 256), True, [
      crypto.WrapKey,
      crypto.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  // Generate a key to be wrapped.
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key_to_wrap) = result

  use result <- promise.await(subtle.wrap_key_jwk(
    key_to_wrap,
    wrapping_key,
    subtle.WrapAesKw,
  ))
  let assert Ok(wrapped_jwk) = result
  should.be_true(bit_array.byte_size(wrapped_jwk) > 0)

  use result <- promise.await(
    subtle.unwrap_key_jwk(
      wrapped_jwk,
      wrapping_key,
      subtle.WrapAesKw,
      subtle.ImportAes(crypto.AesGcm),
      True,
      [crypto.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  key.kind(unwrapped) |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn encrypt_key_usage_mismatch_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  use encrypt_result <- promise.await(
    subtle.encrypt(subtle.EncryptAesGcm(crypto.random_bytes(12)), key, <<
      1,
      2,
      3,
    >>),
  )
  let assert Error(crypto.KeyUsageMismatch(crypto.Encrypt)) = encrypt_result
  promise.resolve(Nil)
}

pub fn export_key_not_extractable_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), False, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key) = result

  use export_result <- promise.await(subtle.export_key(subtle.Raw, key))
  let assert Error(crypto.KeyNotExtractable) = export_result
  promise.resolve(Nil)
}

pub fn digest_algorithm_not_supported_test() {
  use result <- promise.await(
    subtle.digest(crypto.HashOther("MADE-UP-HASH"), <<1, 2, 3>>),
  )
  let assert Error(crypto.AlgorithmNotSupported) = result
  promise.resolve(Nil)
}

pub fn sign_verify_ed25519_test() {
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenEd25519, True, [
      crypto.Sign,
      crypto.Verify,
    ]),
  )
  let assert Ok(pair) = result

  let data = <<"message":utf8>>
  use result <- promise.await(subtle.sign(
    subtle.SignEd25519,
    pair.private_key,
    data,
  ))
  let assert Ok(signature) = result
  should.be_true(bit_array.byte_size(signature) > 0)

  use result <- promise.await(subtle.verify(
    subtle.SignEd25519,
    pair.public_key,
    signature,
    data,
  ))
  let assert Ok(True) = result
  promise.resolve(Nil)
}

pub fn derive_bits_x25519_test() {
  use <- runtime.skip_on(runtime.Bun)
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenX25519, True, [crypto.DeriveBits]),
  )
  let assert Ok(party_a) = result

  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenX25519, True, [crypto.DeriveBits]),
  )
  let assert Ok(party_b) = result

  use result <- promise.await(subtle.derive_bits(
    subtle.DeriveX25519(party_b.public_key),
    party_a.private_key,
    256,
  ))
  let assert Ok(bits) = result
  bit_array.byte_size(bits) |> should.equal(32)
  promise.resolve(Nil)
}

/// Bun (≤ 1.3.12) returns `Error(AlgorithmNotSupported)` for X25519
/// `deriveBits` even though it implements X25519 key generation/import.
/// Tracked at https://github.com/oven-sh/bun/issues/20148; fix merged
/// 2026-04-11 but not yet in 1.3.12.
pub fn derive_bits_x25519_bun_divergence_test() {
  use <- runtime.only_on(runtime.Bun)
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenX25519, True, [crypto.DeriveBits]),
  )
  let assert Ok(party_a) = result

  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenX25519, True, [crypto.DeriveBits]),
  )
  let assert Ok(party_b) = result

  use result <- promise.await(subtle.derive_bits(
    subtle.DeriveX25519(party_b.public_key),
    party_a.private_key,
    256,
  ))
  let assert Error(crypto.AlgorithmNotSupported) = result
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_aes_gcm_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.WrapKey,
      crypto.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesCbc, 256), True, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key_to_wrap) = result

  let iv = crypto.random_bytes(12)
  use result <- promise.await(subtle.wrap_key(
    subtle.Raw,
    key_to_wrap,
    wrapping_key,
    subtle.WrapAesGcm(iv),
  ))
  let assert Ok(wrapped) = result
  should.be_true(bit_array.byte_size(wrapped) > 0)

  use result <- promise.await(
    subtle.unwrap_key(
      subtle.Raw,
      wrapped,
      wrapping_key,
      subtle.WrapAesGcm(iv),
      subtle.ImportAes(crypto.AesCbc),
      True,
      [crypto.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  key.kind(unwrapped) |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_aes_gcm_with_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesGcm, 256), True, [
      crypto.WrapKey,
      crypto.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  use result <- promise.await(
    subtle.generate_key(subtle.KeyGenAes(crypto.AesCbc, 256), True, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key_to_wrap) = result

  let iv = crypto.random_bytes(12)
  let aad = <<"context":utf8>>
  use result <- promise.await(subtle.wrap_key(
    subtle.Raw,
    key_to_wrap,
    wrapping_key,
    subtle.WrapAesGcmWith(iv, aad, 128),
  ))
  let assert Ok(wrapped) = result
  should.be_true(bit_array.byte_size(wrapped) > 0)

  use result <- promise.await(
    subtle.unwrap_key(
      subtle.Raw,
      wrapped,
      wrapping_key,
      subtle.WrapAesGcmWith(iv, aad, 128),
      subtle.ImportAes(crypto.AesCbc),
      True,
      [crypto.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  key.kind(unwrapped) |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn import_ed25519_public_test() {
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenEd25519, True, [
      crypto.Sign,
      crypto.Verify,
    ]),
  )
  let assert Ok(pair) = result

  use result <- promise.await(subtle.export_key(subtle.Spki, pair.public_key))
  let assert Ok(exported) = result

  use result <- promise.await(
    subtle.import_key(subtle.Spki, exported, subtle.ImportEd25519, True, [
      crypto.Verify,
    ]),
  )
  let assert Ok(imported) = result
  key.kind(imported) |> should.equal(crypto.Public)
  promise.resolve(Nil)
}

pub fn import_x25519_public_test() {
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenX25519, True, [crypto.DeriveBits]),
  )
  let assert Ok(pair) = result

  use result <- promise.await(subtle.export_key(subtle.Spki, pair.public_key))
  let assert Ok(exported) = result

  use result <- promise.await(
    subtle.import_key(subtle.Spki, exported, subtle.ImportX25519, True, []),
  )
  let assert Ok(imported) = result
  key.kind(imported) |> should.equal(crypto.Public)
  promise.resolve(Nil)
}

pub fn import_hkdf_base_key_test() {
  let key_material = crypto.random_bytes(32)
  use result <- promise.await(
    subtle.import_key(subtle.Raw, key_material, subtle.ImportHkdf, False, [
      crypto.DeriveBits,
    ]),
  )
  let assert Ok(base_key) = result
  key.kind(base_key) |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}
