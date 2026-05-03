import * as $alg from "$/gossamer/gossamer/subtle_crypto/key_pair_gen_algorithm.mjs";
import { toEcAlgorithm } from "~/gossamer/ec_algorithm.ffi.ts";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ffi.ts";
import { toNamedCurve } from "~/gossamer/named_curve.ffi.ts";
import { toRsaAlgorithm } from "~/gossamer/rsa_algorithm.ffi.ts";
import { unwrap as unwrapTypedArray } from "~/gossamer/typed_array.ffi.ts";

export function toKeyPairGenAlgorithm(
  algorithm: $alg.KeyPairGenAlgorithm$,
): AlgorithmIdentifier | RsaHashedKeyGenParams | EcKeyGenParams {
  if ($alg.KeyPairGenAlgorithm$isOther(algorithm)) {
    return $alg.KeyPairGenAlgorithm$Other$0(algorithm);
  }
  if ($alg.KeyPairGenAlgorithm$isRsa(algorithm)) {
    return {
      name: toRsaAlgorithm($alg.KeyPairGenAlgorithm$Rsa$name(algorithm)),
      modulusLength: $alg.KeyPairGenAlgorithm$Rsa$modulus_length(algorithm),
      publicExponent: unwrapTypedArray(
        $alg.KeyPairGenAlgorithm$Rsa$public_exponent(algorithm),
      ) as BigInteger,
      hash: toHashAlgorithm($alg.KeyPairGenAlgorithm$Rsa$hash(algorithm)),
    };
  }
  if ($alg.KeyPairGenAlgorithm$isEd25519(algorithm)) return "Ed25519";
  if ($alg.KeyPairGenAlgorithm$isX25519(algorithm)) return "X25519";
  return {
    name: toEcAlgorithm($alg.KeyPairGenAlgorithm$Ec$name(algorithm)),
    namedCurve: toNamedCurve(
      $alg.KeyPairGenAlgorithm$Ec$named_curve(algorithm),
    ),
  };
}
