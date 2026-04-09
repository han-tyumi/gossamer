import * as $alg from "$/gossamer/gossamer/subtle_crypto/import_algorithm.mjs";
import { toEcAlgorithm } from "~/gossamer/ec_algorithm.ts";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ts";
import { toNamedCurve } from "~/gossamer/named_curve.ts";
import { toRsaAlgorithm } from "~/gossamer/rsa_algorithm.ts";

export function toImportAlgorithm(
  algorithm: $alg.ImportAlgorithm$,
):
  | AlgorithmIdentifier
  | HmacImportParams
  | RsaHashedImportParams
  | EcKeyImportParams {
  if ($alg.ImportAlgorithm$isName(algorithm)) {
    return $alg.ImportAlgorithm$Name$0(algorithm);
  }
  if ($alg.ImportAlgorithm$isHmacImport(algorithm)) {
    return {
      name: "HMAC",
      hash: toHashAlgorithm($alg.ImportAlgorithm$HmacImport$hash(algorithm)),
    };
  }
  if ($alg.ImportAlgorithm$isRsaHashedImport(algorithm)) {
    return {
      name: toRsaAlgorithm(
        $alg.ImportAlgorithm$RsaHashedImport$name(algorithm),
      ),
      hash: toHashAlgorithm(
        $alg.ImportAlgorithm$RsaHashedImport$hash(algorithm),
      ),
    };
  }
  return {
    name: toEcAlgorithm($alg.ImportAlgorithm$EcImport$name(algorithm)),
    namedCurve: toNamedCurve(
      $alg.ImportAlgorithm$EcImport$named_curve(algorithm),
    ),
  };
}
