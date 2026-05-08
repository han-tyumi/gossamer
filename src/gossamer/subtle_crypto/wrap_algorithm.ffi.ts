import * as $alg from "$/gossamer/gossamer/subtle_crypto/wrap_algorithm.mjs";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";

export function toWrapAlgorithm(
  algorithm: $alg.WrapAlgorithm$,
): AlgorithmIdentifier | AesCbcParams | AesCtrParams | RsaOaepParams {
  if ($alg.WrapAlgorithm$isOther(algorithm)) {
    return $alg.WrapAlgorithm$Other$0(algorithm);
  }
  if ($alg.WrapAlgorithm$isAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: toBufferSource($alg.WrapAlgorithm$AesCbc$iv(algorithm)),
    };
  }
  if ($alg.WrapAlgorithm$isAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: toBufferSource(
        $alg.WrapAlgorithm$AesCtr$counter(algorithm),
      ),
      length: $alg.WrapAlgorithm$AesCtr$length(algorithm),
    };
  }
  if ($alg.WrapAlgorithm$isRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: toBufferSource(
        $alg.WrapAlgorithm$RsaOaepWith$label(algorithm),
      ),
    };
  }
  return { name: "RSA-OAEP" };
}
