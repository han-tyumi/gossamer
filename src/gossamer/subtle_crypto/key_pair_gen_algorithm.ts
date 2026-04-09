import * as $alg from "$/gossamer/gossamer/subtle_crypto/key_pair_gen_algorithm.mjs";
import { toEcAlgorithm } from "~/gossamer/ec_algorithm.ts";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ts";
import { toNamedCurve } from "~/gossamer/named_curve.ts";
import { toRsaAlgorithm } from "~/gossamer/rsa_algorithm.ts";

export function toKeyPairGenAlgorithm(
  algorithm: $alg.KeyPairGenAlgorithm$,
): RsaHashedKeyGenParams | EcKeyGenParams {
  if ($alg.KeyPairGenAlgorithm$isRsa(algorithm)) {
    return {
      name: toRsaAlgorithm($alg.KeyPairGenAlgorithm$Rsa$name(algorithm)),
      modulusLength: $alg.KeyPairGenAlgorithm$Rsa$modulus_length(algorithm),
      publicExponent: $alg.KeyPairGenAlgorithm$Rsa$public_exponent(
        algorithm,
      ) as unknown as BigInteger,
      hash: toHashAlgorithm($alg.KeyPairGenAlgorithm$Rsa$hash(algorithm)),
    };
  }
  return {
    name: toEcAlgorithm($alg.KeyPairGenAlgorithm$Ec$name(algorithm)),
    namedCurve: toNamedCurve(
      $alg.KeyPairGenAlgorithm$Ec$named_curve(algorithm),
    ),
  };
}
