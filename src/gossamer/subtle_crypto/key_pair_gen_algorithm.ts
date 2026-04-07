import * as $alg from "$/gossamer/gossamer/subtle_crypto/key_pair_gen_algorithm.mjs";

export function toKeyPairGenAlgorithm(
  algorithm: $alg.KeyPairGenAlgorithm$,
): RsaHashedKeyGenParams | EcKeyGenParams {
  if ($alg.KeyPairGenAlgorithm$isRsa(algorithm)) {
    return {
      name: $alg.KeyPairGenAlgorithm$Rsa$name(algorithm),
      modulusLength: $alg.KeyPairGenAlgorithm$Rsa$modulus_length(algorithm),
      publicExponent: $alg.KeyPairGenAlgorithm$Rsa$public_exponent(
        algorithm,
      ) as unknown as BigInteger,
      hash: $alg.KeyPairGenAlgorithm$Rsa$hash(algorithm),
    };
  }
  return {
    name: $alg.KeyPairGenAlgorithm$Ec$name(algorithm),
    namedCurve: $alg.KeyPairGenAlgorithm$Ec$named_curve(algorithm),
  };
}
