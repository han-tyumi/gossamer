import * as $alg from "$/gossamer/gossamer/subtle_crypto/encrypt_algorithm.mjs";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";

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
      iv: toBufferSource($alg.EncryptAlgorithm$AesCbc$iv(algorithm)),
    };
  }
  if ($alg.EncryptAlgorithm$isAesGcm(algorithm)) {
    return {
      name: "AES-GCM",
      iv: toBufferSource($alg.EncryptAlgorithm$AesGcm$iv(algorithm)),
    };
  }
  if ($alg.EncryptAlgorithm$isAesGcmWith(algorithm)) {
    return {
      name: "AES-GCM",
      iv: toBufferSource(
        $alg.EncryptAlgorithm$AesGcmWith$iv(algorithm),
      ),
      additionalData: toBufferSource(
        $alg.EncryptAlgorithm$AesGcmWith$additional_data(algorithm),
      ),
      tagLength: $alg.EncryptAlgorithm$AesGcmWith$tag_length(algorithm),
    };
  }
  if ($alg.EncryptAlgorithm$isAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: toBufferSource(
        $alg.EncryptAlgorithm$AesCtr$counter(algorithm),
      ),
      length: $alg.EncryptAlgorithm$AesCtr$length(algorithm),
    };
  }
  if ($alg.EncryptAlgorithm$isRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: toBufferSource(
        $alg.EncryptAlgorithm$RsaOaepWith$label(algorithm),
      ),
    };
  }
  return { name: "RSA-OAEP" };
}
