import * as $cryptoKey from "$/gossamer/gossamer/crypto_key.mjs";
import * as $alg from "$/gossamer/gossamer/subtle_crypto/derive_algorithm.mjs";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ffi.ts";

export function toDeriveAlgorithm(
  algorithm: $alg.DeriveAlgorithm$,
): AlgorithmIdentifier | HkdfParams | Pbkdf2Params | EcdhKeyDeriveParams {
  if ($alg.DeriveAlgorithm$isOther(algorithm)) {
    return $alg.DeriveAlgorithm$Other$0(algorithm);
  }
  if ($alg.DeriveAlgorithm$isHkdf(algorithm)) {
    return {
      name: "HKDF",
      hash: toHashAlgorithm($alg.DeriveAlgorithm$Hkdf$hash(algorithm)),
      info: $alg.DeriveAlgorithm$Hkdf$info(
        algorithm,
      ) as unknown as BufferSource,
      salt: $alg.DeriveAlgorithm$Hkdf$salt(
        algorithm,
      ) as unknown as BufferSource,
    };
  }
  if ($alg.DeriveAlgorithm$isPbkdf2(algorithm)) {
    return {
      name: "PBKDF2",
      hash: toHashAlgorithm($alg.DeriveAlgorithm$Pbkdf2$hash(algorithm)),
      iterations: $alg.DeriveAlgorithm$Pbkdf2$iterations(algorithm),
      salt: $alg.DeriveAlgorithm$Pbkdf2$salt(
        algorithm,
      ) as unknown as BufferSource,
    };
  }
  return {
    name: "ECDH",
    public: $cryptoKey.CryptoKey$CryptoKey$ref(
      $alg.DeriveAlgorithm$Ecdh$public(algorithm),
    ),
  };
}
