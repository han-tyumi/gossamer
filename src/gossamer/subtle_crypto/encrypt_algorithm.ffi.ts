import * as $alg from "$/gossamer/gossamer/subtle_crypto/encrypt_algorithm.mjs";

export function toEncryptAlgorithm(
  algorithm: $alg.EncryptAlgorithm$,
):
  | AlgorithmIdentifier
  | AesCbcParams
  | AesGcmParams
  | AesCtrParams
  | RsaOaepParams {
  if ($alg.EncryptAlgorithm$isOther(algorithm)) {
    return $alg.EncryptAlgorithm$Other$0(algorithm);
  }
  if ($alg.EncryptAlgorithm$isAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: $alg.EncryptAlgorithm$AesCbc$iv(algorithm) as unknown as BufferSource,
    };
  }
  if ($alg.EncryptAlgorithm$isAesGcm(algorithm)) {
    return {
      name: "AES-GCM",
      iv: $alg.EncryptAlgorithm$AesGcm$iv(algorithm) as unknown as BufferSource,
    };
  }
  if ($alg.EncryptAlgorithm$isAesGcmWith(algorithm)) {
    return {
      name: "AES-GCM",
      iv: $alg.EncryptAlgorithm$AesGcmWith$iv(
        algorithm,
      ) as unknown as BufferSource,
      additionalData: $alg.EncryptAlgorithm$AesGcmWith$additional_data(
        algorithm,
      ) as unknown as BufferSource,
      tagLength: $alg.EncryptAlgorithm$AesGcmWith$tag_length(algorithm),
    };
  }
  if ($alg.EncryptAlgorithm$isAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: $alg.EncryptAlgorithm$AesCtr$counter(
        algorithm,
      ) as unknown as BufferSource,
      length: $alg.EncryptAlgorithm$AesCtr$length(algorithm),
    };
  }
  if ($alg.EncryptAlgorithm$isRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: $alg.EncryptAlgorithm$RsaOaepWith$label(
        algorithm,
      ) as unknown as BufferSource,
    };
  }
  return { name: "RSA-OAEP" };
}
