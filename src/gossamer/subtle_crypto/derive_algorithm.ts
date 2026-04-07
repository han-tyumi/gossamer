import * as $alg from "$/gossamer/gossamer/subtle_crypto/derive_algorithm.mjs";

export function toDeriveAlgorithm(
  algorithm: $alg.DeriveAlgorithm$,
): AlgorithmIdentifier | HkdfParams | Pbkdf2Params | EcdhKeyDeriveParams {
  if ($alg.DeriveAlgorithm$isName(algorithm)) {
    return $alg.DeriveAlgorithm$Name$0(algorithm);
  }
  if ($alg.DeriveAlgorithm$isHkdf(algorithm)) {
    return {
      name: "HKDF",
      hash: $alg.DeriveAlgorithm$Hkdf$hash(algorithm),
      info: $alg.DeriveAlgorithm$Hkdf$info(
        algorithm,
      ) as unknown as BufferSource,
      salt: $alg.DeriveAlgorithm$Hkdf$salt(
        algorithm,
      ) as unknown as BufferSource,
    };
  }
  if ($alg.DeriveAlgorithm$isPbkdf2(algorithm)) {
    return {
      name: "PBKDF2",
      hash: $alg.DeriveAlgorithm$Pbkdf2$hash(algorithm),
      iterations: $alg.DeriveAlgorithm$Pbkdf2$iterations(algorithm),
      salt: $alg.DeriveAlgorithm$Pbkdf2$salt(
        algorithm,
      ) as unknown as BufferSource,
    };
  }
  return {
    name: "ECDH",
    public: $alg.DeriveAlgorithm$Ecdh$public(algorithm),
  };
}
