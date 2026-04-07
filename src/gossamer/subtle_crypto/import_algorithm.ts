import * as $alg from "$/gossamer/gossamer/subtle_crypto/import_algorithm.mjs";

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
      hash: $alg.ImportAlgorithm$HmacImport$hash(algorithm),
    };
  }
  if ($alg.ImportAlgorithm$isRsaHashedImport(algorithm)) {
    return {
      name: $alg.ImportAlgorithm$RsaHashedImport$name(algorithm),
      hash: $alg.ImportAlgorithm$RsaHashedImport$hash(algorithm),
    };
  }
  return {
    name: $alg.ImportAlgorithm$EcImport$name(algorithm),
    namedCurve: $alg.ImportAlgorithm$EcImport$named_curve(algorithm),
  };
}
