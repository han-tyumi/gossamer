import * as $alg from "$/gossamer/gossamer/subtle_crypto/derive_algorithm.mjs";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";
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
      info: toBufferSource($alg.DeriveAlgorithm$Hkdf$info(algorithm)),
      salt: toBufferSource($alg.DeriveAlgorithm$Hkdf$salt(algorithm)),
    };
  }
  if ($alg.DeriveAlgorithm$isPbkdf2(algorithm)) {
    return {
      name: "PBKDF2",
      hash: toHashAlgorithm($alg.DeriveAlgorithm$Pbkdf2$hash(algorithm)),
      iterations: $alg.DeriveAlgorithm$Pbkdf2$iterations(algorithm),
      salt: toBufferSource(
        $alg.DeriveAlgorithm$Pbkdf2$salt(algorithm),
      ),
    };
  }
  return {
    name: "ECDH",
    public: $alg.DeriveAlgorithm$Ecdh$public(algorithm),
  };
}
