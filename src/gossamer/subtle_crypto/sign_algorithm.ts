import * as $alg from "$/gossamer/gossamer/subtle_crypto/sign_algorithm.mjs";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ts";

export function toSignAlgorithm(
  algorithm: $alg.SignAlgorithm$,
): AlgorithmIdentifier | RsaPssParams | EcdsaParams {
  if ($alg.SignAlgorithm$isName(algorithm)) {
    return $alg.SignAlgorithm$Name$0(algorithm);
  }
  if ($alg.SignAlgorithm$isHmac(algorithm)) return "HMAC";
  if ($alg.SignAlgorithm$isRsassaPkcs1V15(algorithm)) {
    return "RSASSA-PKCS1-v1_5";
  }
  if ($alg.SignAlgorithm$isRsaPss(algorithm)) {
    return {
      name: "RSA-PSS",
      saltLength: $alg.SignAlgorithm$RsaPss$salt_length(algorithm),
    };
  }
  return {
    name: "ECDSA",
    hash: toHashAlgorithm($alg.SignAlgorithm$Ecdsa$hash(algorithm)),
  };
}
