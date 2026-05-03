import * as $alg from "$/gossamer/gossamer/subtle_crypto/wrap_algorithm.mjs";
import { unwrap as unwrapTypedArray } from "~/gossamer/typed_array.ffi.ts";

export function toWrapAlgorithm(
  algorithm: $alg.WrapAlgorithm$,
): AlgorithmIdentifier | AesCbcParams | AesCtrParams | RsaOaepParams {
  if ($alg.WrapAlgorithm$isOther(algorithm)) {
    return $alg.WrapAlgorithm$Other$0(algorithm);
  }
  if ($alg.WrapAlgorithm$isAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: unwrapTypedArray(
        $alg.WrapAlgorithm$AesCbc$iv(algorithm),
      ) as BufferSource,
    };
  }
  if ($alg.WrapAlgorithm$isAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: unwrapTypedArray(
        $alg.WrapAlgorithm$AesCtr$counter(algorithm),
      ) as BufferSource,
      length: $alg.WrapAlgorithm$AesCtr$length(algorithm),
    };
  }
  if ($alg.WrapAlgorithm$isRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: unwrapTypedArray(
        $alg.WrapAlgorithm$RsaOaepWith$label(algorithm),
      ) as BufferSource,
    };
  }
  return { name: "RSA-OAEP" };
}
