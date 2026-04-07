import * as $alg from "$/gossamer/gossamer/subtle_crypto/key_gen_algorithm.mjs";

export function toKeyGenAlgorithm(
  algorithm: $alg.KeyGenAlgorithm$,
): AesKeyGenParams | HmacKeyGenParams {
  if ($alg.KeyGenAlgorithm$isAes(algorithm)) {
    return {
      name: $alg.KeyGenAlgorithm$Aes$name(algorithm),
      length: $alg.KeyGenAlgorithm$Aes$length(algorithm),
    };
  }
  return {
    name: "HMAC",
    hash: $alg.KeyGenAlgorithm$HmacGen$hash(algorithm),
  };
}
