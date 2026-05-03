import * as $alg from "$/gossamer/gossamer/subtle_crypto/derive_algorithm.mjs";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ffi.ts";
import { unwrap as unwrapTypedArray } from "~/gossamer/typed_array.ffi.ts";

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
      info: unwrapTypedArray(
        $alg.DeriveAlgorithm$Hkdf$info(algorithm),
      ) as BufferSource,
      salt: unwrapTypedArray(
        $alg.DeriveAlgorithm$Hkdf$salt(algorithm),
      ) as BufferSource,
    };
  }
  if ($alg.DeriveAlgorithm$isPbkdf2(algorithm)) {
    return {
      name: "PBKDF2",
      hash: toHashAlgorithm($alg.DeriveAlgorithm$Pbkdf2$hash(algorithm)),
      iterations: $alg.DeriveAlgorithm$Pbkdf2$iterations(algorithm),
      salt: unwrapTypedArray(
        $alg.DeriveAlgorithm$Pbkdf2$salt(algorithm),
      ) as BufferSource,
    };
  }
  return {
    name: "ECDH",
    public: $alg.DeriveAlgorithm$Ecdh$public(algorithm),
  };
}
