import * as $alg from "$/gossamer/gossamer/subtle_crypto/wrap_algorithm.mjs";

export function toWrapAlgorithm(
  algorithm: $alg.WrapAlgorithm$,
): AlgorithmIdentifier | AesCbcParams | AesCtrParams | RsaOaepParams {
  if ($alg.WrapAlgorithm$isOther(algorithm)) {
    return $alg.WrapAlgorithm$Other$0(algorithm);
  }
  if ($alg.WrapAlgorithm$isAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: $alg.WrapAlgorithm$AesCbc$iv(algorithm) as unknown as BufferSource,
    };
  }
  if ($alg.WrapAlgorithm$isAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: $alg.WrapAlgorithm$AesCtr$counter(
        algorithm,
      ) as unknown as BufferSource,
      length: $alg.WrapAlgorithm$AesCtr$length(algorithm),
    };
  }
  if ($alg.WrapAlgorithm$isRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: $alg.WrapAlgorithm$RsaOaepWith$label(
        algorithm,
      ) as unknown as BufferSource,
    };
  }
  return { name: "RSA-OAEP" };
}
