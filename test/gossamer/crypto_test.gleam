import gleam/bit_array
import gleam/crypto as gleam_crypto
import gleam/javascript/promise
import gleam/list
import gleam/option
import gleam/string
import gleeunit/should
import gossamer/crypto
import gossamer/crypto/key
import gossamer/crypto/subtle
import runtime

pub fn random_uuid_test() {
  let uuid = crypto.random_uuid()
  should.equal(string.length(uuid), 36)
}

pub fn digest_test() {
  let data = <<1, 2, 3>>
  use hash <- promise.await(subtle.digest(crypto.Sha256, data))
  should.equal(bit_array.byte_size(hash), 32)
  promise.resolve(Nil)
}

pub fn digest_unaligned_test() {
  let unaligned = <<1:size(7)>>
  use hash <- promise.await(subtle.digest(crypto.Sha256, unaligned))
  should.equal(bit_array.byte_size(hash), 32)
  promise.resolve(Nil)
}

pub fn generate_key_and_encrypt_decrypt_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result
  let info = key.info(key)

  should.equal(info.extractable, True)
  should.equal(info.kind, crypto.Secret)

  let iv = gleam_crypto.strong_random_bytes(12)
  let plaintext = <<"Hello":utf8>>

  use result <- promise.await(subtle.encrypt(
    subtle.EncryptAesGcm(iv, <<>>, option.None),
    key,
    plaintext,
  ))
  let assert Ok(ciphertext) = result
  should.be_true(bit_array.byte_size(ciphertext) > 0)

  use result <- promise.await(subtle.decrypt(
    subtle.EncryptAesGcm(iv, <<>>, option.None),
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
      subtle.KeyPairGenEc(crypto.Dsa, crypto.P256),
      True,
      [
        crypto.Sign,
        crypto.Verify,
      ],
    ),
  )
  let assert Ok(pair) = result

  let subtle.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(key.info(public_key).kind, crypto.Public)
  should.equal(key.info(private_key).kind, crypto.Private)

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
      subtle.KeyPairGenRsa(crypto.SsaPkcs1V15, 2048, <<1, 0, 1>>, crypto.Sha256),
      True,
      [crypto.Sign, crypto.Verify],
    ),
  )
  let assert Ok(pair) = result
  let subtle.CryptoKeyPair(public_key:, private_key:) = pair
  should.equal(key.info(public_key).kind, crypto.Public)
  should.equal(key.info(private_key).kind, crypto.Private)
  let algo = key.info(private_key).algorithm
  let assert crypto.Rsa(name:, modulus_length:, ..) = algo
  should.equal(name, crypto.SsaPkcs1V15)
  should.equal(modulus_length, 2048)
  promise.resolve(Nil)
}

pub fn import_export_key_test() {
  let raw_key = gleam_crypto.strong_random_bytes(16)

  use result <- promise.await(
    subtle.import_key(subtle.Raw, raw_key, subtle.ImportAes(crypto.Gcm), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  should.equal(key.info(key).extractable, True)

  use result <- promise.await(subtle.export_key(subtle.Raw, key))
  let assert Ok(exported) = result
  should.equal(bit_array.byte_size(exported), 16)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key) = result
  let algo = key.info(key).algorithm
  should.equal(algo, crypto.Aes(crypto.Gcm, 256))
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
  key.info(pair.public_key).algorithm |> should.equal(crypto.Ed25519)
  key.info(pair.private_key).algorithm |> should.equal(crypto.Ed25519)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_x25519_test() {
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenX25519, True, [crypto.DeriveBits]),
  )
  let assert Ok(pair) = result
  key.info(pair.public_key).algorithm |> should.equal(crypto.X25519)
  key.info(pair.private_key).algorithm |> should.equal(crypto.X25519)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_hkdf_test() {
  use result <- promise.await(
    subtle.import_key(
      subtle.Raw,
      gleam_crypto.strong_random_bytes(32),
      subtle.ImportHkdf,
      False,
      [crypto.DeriveBits],
    ),
  )
  let assert Ok(base_key) = result
  key.info(base_key).algorithm |> should.equal(crypto.Hkdf)
  promise.resolve(Nil)
}

pub fn crypto_key_algorithm_pbkdf2_test() {
  use result <- promise.await(
    subtle.import_key(subtle.Raw, <<"pass":utf8>>, subtle.ImportPbkdf2, False, [
      crypto.DeriveBits,
    ]),
  )
  let assert Ok(base_key) = result
  key.info(base_key).algorithm |> should.equal(crypto.Pbkdf2)
  promise.resolve(Nil)
}

pub fn crypto_key_usages_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result
  let usages = key.info(key).usages
  should.be_true(list.contains(usages, crypto.Encrypt))
  should.be_true(list.contains(usages, crypto.Decrypt))
  should.equal(list.length(usages), 2)
  promise.resolve(Nil)
}

pub fn export_key_jwk_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
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
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  use result <- promise.await(subtle.export_key_jwk(key))
  let assert Ok(jwk) = result

  use result <- promise.await(
    subtle.import_key_jwk(jwk, subtle.ImportAes(crypto.Gcm), True, [
      crypto.Encrypt,
      crypto.Decrypt,
    ]),
  )
  let assert Ok(imported) = result
  key.info(imported).kind |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn derive_bits_test() {
  let password = <<"pass":utf8>>
  let salt = gleam_crypto.strong_random_bytes(16)

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
  let salt = gleam_crypto.strong_random_bytes(16)

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
      subtle.Aes(crypto.Gcm, 256),
      True,
      [crypto.Encrypt, crypto.Decrypt],
    ),
  )
  let assert Ok(derived) = result
  key.info(derived).kind |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_test() {
  // Generate a wrapping key (AES-KW).
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Kw, 256), True, [
      crypto.WrapKey,
      crypto.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  // Generate a key to be wrapped.
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
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
      subtle.ImportAes(crypto.Gcm),
      True,
      [crypto.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  key.info(unwrapped).kind |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_jwk_test() {
  // Generate a wrapping key (AES-KW).
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Kw, 256), True, [
      crypto.WrapKey,
      crypto.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  // Generate a key to be wrapped.
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
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
      subtle.ImportAes(crypto.Gcm),
      True,
      [crypto.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  key.info(unwrapped).kind |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn encrypt_key_usage_mismatch_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
      crypto.Decrypt,
    ]),
  )
  let assert Ok(key) = result

  use encrypt_result <- promise.await(
    subtle.encrypt(
      subtle.EncryptAesGcm(
        gleam_crypto.strong_random_bytes(12),
        <<>>,
        option.None,
      ),
      key,
      <<
        1,
        2,
        3,
      >>,
    ),
  )
  let assert Error(crypto.KeyUsageMismatch(crypto.Encrypt)) = encrypt_result
  promise.resolve(Nil)
}

pub fn export_key_not_extractable_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), False, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key) = result

  use export_result <- promise.await(subtle.export_key(subtle.Raw, key))
  let assert Error(crypto.KeyNotExtractable) = export_result
  promise.resolve(Nil)
}

pub fn generate_key_empty_usages_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, []),
  )
  let assert Error(crypto.InvalidSyntax) = result
  promise.resolve(Nil)
}

pub fn import_key_empty_usages_test() {
  use result <- promise.await(
    subtle.import_key(
      subtle.Raw,
      gleam_crypto.strong_random_bytes(16),
      subtle.ImportAes(crypto.Gcm),
      True,
      [],
    ),
  )
  let assert Error(crypto.InvalidSyntax) = result
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

fn derive_zero_length_ec_dh_bits() -> promise.Promise(Int) {
  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenEc(crypto.Dh, crypto.P256), True, [
      crypto.DeriveBits,
    ]),
  )
  let assert Ok(party_a) = result

  use result <- promise.await(
    subtle.generate_key_pair(subtle.KeyPairGenEc(crypto.Dh, crypto.P256), True, [
      crypto.DeriveBits,
    ]),
  )
  let assert Ok(party_b) = result

  use result <- promise.await(subtle.derive_bits(
    subtle.DeriveEcDh(party_b.public_key),
    party_a.private_key,
    0,
  ))
  let assert Ok(bits) = result
  promise.resolve(bit_array.byte_size(bits))
}

pub fn derive_bits_zero_length_test() {
  use <- runtime.skip_on(runtime.Bun)
  use size <- promise.await(derive_zero_length_ec_dh_bits())
  size |> should.equal(0)
  promise.resolve(Nil)
}

/// Bun resolves a zero-length `derive_bits` with the full shared secret
/// where the Web Crypto spec (and Node and Deno) produce an empty result.
pub fn derive_bits_zero_length_bun_divergence_test() {
  use <- runtime.only_on(runtime.Bun)
  use size <- promise.await(derive_zero_length_ec_dh_bits())
  size |> should.equal(32)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_aes_gcm_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
      crypto.WrapKey,
      crypto.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Cbc, 256), True, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key_to_wrap) = result

  let iv = gleam_crypto.strong_random_bytes(12)
  use result <- promise.await(subtle.wrap_key(
    subtle.Raw,
    key_to_wrap,
    wrapping_key,
    subtle.WrapAesGcm(iv, <<>>, option.None),
  ))
  let assert Ok(wrapped) = result
  should.be_true(bit_array.byte_size(wrapped) > 0)

  use result <- promise.await(
    subtle.unwrap_key(
      subtle.Raw,
      wrapped,
      wrapping_key,
      subtle.WrapAesGcm(iv, <<>>, option.None),
      subtle.ImportAes(crypto.Cbc),
      True,
      [crypto.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  key.info(unwrapped).kind |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}

pub fn wrap_unwrap_key_aes_gcm_with_test() {
  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Gcm, 256), True, [
      crypto.WrapKey,
      crypto.UnwrapKey,
    ]),
  )
  let assert Ok(wrapping_key) = result

  use result <- promise.await(
    subtle.generate_key(subtle.Aes(crypto.Cbc, 256), True, [
      crypto.Encrypt,
    ]),
  )
  let assert Ok(key_to_wrap) = result

  let iv = gleam_crypto.strong_random_bytes(12)
  let aad = <<"context":utf8>>
  use result <- promise.await(subtle.wrap_key(
    subtle.Raw,
    key_to_wrap,
    wrapping_key,
    subtle.WrapAesGcm(iv, aad, option.Some(128)),
  ))
  let assert Ok(wrapped) = result
  should.be_true(bit_array.byte_size(wrapped) > 0)

  use result <- promise.await(
    subtle.unwrap_key(
      subtle.Raw,
      wrapped,
      wrapping_key,
      subtle.WrapAesGcm(iv, aad, option.Some(128)),
      subtle.ImportAes(crypto.Cbc),
      True,
      [crypto.Encrypt],
    ),
  )
  let assert Ok(unwrapped) = result
  key.info(unwrapped).kind |> should.equal(crypto.Secret)
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
  key.info(imported).kind |> should.equal(crypto.Public)
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
  key.info(imported).kind |> should.equal(crypto.Public)
  promise.resolve(Nil)
}

pub fn import_hkdf_base_key_test() {
  let key_material = gleam_crypto.strong_random_bytes(32)
  use result <- promise.await(
    subtle.import_key(subtle.Raw, key_material, subtle.ImportHkdf, False, [
      crypto.DeriveBits,
    ]),
  )
  let assert Ok(base_key) = result
  key.info(base_key).kind |> should.equal(crypto.Secret)
  promise.resolve(Nil)
}
