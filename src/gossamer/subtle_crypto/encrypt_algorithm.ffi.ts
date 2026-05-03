import * as $alg from "$/gossamer/gossamer/subtle_crypto/encrypt_algorithm.mjs";
import { unwrap as unwrapTypedArray } from "~/gossamer/typed_array.ffi.ts";

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
      iv: unwrapTypedArray(
        $alg.EncryptAlgorithm$AesCbc$iv(algorithm),
      ) as BufferSource,
    };
  }
  if ($alg.EncryptAlgorithm$isAesGcm(algorithm)) {
    return {
      name: "AES-GCM",
      iv: unwrapTypedArray(
        $alg.EncryptAlgorithm$AesGcm$iv(algorithm),
      ) as BufferSource,
    };
  }
  if ($alg.EncryptAlgorithm$isAesGcmWith(algorithm)) {
    return {
      name: "AES-GCM",
      iv: unwrapTypedArray(
        $alg.EncryptAlgorithm$AesGcmWith$iv(algorithm),
      ) as BufferSource,
      additionalData: unwrapTypedArray(
        $alg.EncryptAlgorithm$AesGcmWith$additional_data(algorithm),
      ) as BufferSource,
      tagLength: $alg.EncryptAlgorithm$AesGcmWith$tag_length(algorithm),
    };
  }
  if ($alg.EncryptAlgorithm$isAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: unwrapTypedArray(
        $alg.EncryptAlgorithm$AesCtr$counter(algorithm),
      ) as BufferSource,
      length: $alg.EncryptAlgorithm$AesCtr$length(algorithm),
    };
  }
  if ($alg.EncryptAlgorithm$isRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: unwrapTypedArray(
        $alg.EncryptAlgorithm$RsaOaepWith$label(algorithm),
      ) as BufferSource,
    };
  }
  return { name: "RSA-OAEP" };
}
