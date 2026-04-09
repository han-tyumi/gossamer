import * as $alg from "$/gossamer/gossamer/subtle_crypto/key_gen_algorithm.mjs";
import { toAesAlgorithm } from "~/gossamer/aes_algorithm.ts";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ts";

export function toKeyGenAlgorithm(
  algorithm: $alg.KeyGenAlgorithm$,
): AlgorithmIdentifier | AesKeyGenParams | HmacKeyGenParams {
  if ($alg.KeyGenAlgorithm$isOther(algorithm)) {
    return $alg.KeyGenAlgorithm$Other$0(algorithm);
  }
  if ($alg.KeyGenAlgorithm$isAes(algorithm)) {
    return {
      name: toAesAlgorithm($alg.KeyGenAlgorithm$Aes$name(algorithm)),
      length: $alg.KeyGenAlgorithm$Aes$length(algorithm),
    };
  }
  return {
    name: "HMAC",
    hash: toHashAlgorithm($alg.KeyGenAlgorithm$HmacGen$hash(algorithm)),
  };
}
