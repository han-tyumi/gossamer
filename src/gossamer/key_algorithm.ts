import * as $keyAlgorithm from "$/gossamer/gossamer/key_algorithm.mjs";

interface AesAlgorithm extends KeyAlgorithm {
  length: number;
}

interface EcAlgorithm extends KeyAlgorithm {
  namedCurve: string;
}

interface HmacAlgorithm extends KeyAlgorithm {
  hash: AlgorithmIdentifier;
  length: number;
}

interface RsaAlgorithm extends KeyAlgorithm {
  modulusLength: number;
  publicExponent: Uint8Array;
  hash: AlgorithmIdentifier;
}

function hashName(hash: AlgorithmIdentifier): string {
  return typeof hash === "string" ? hash : hash.name;
}

export function toKeyAlgorithm(
  algorithm: KeyAlgorithm,
): $keyAlgorithm.KeyAlgorithm$ {
  const name = algorithm.name;

  if ("namedCurve" in algorithm) {
    return $keyAlgorithm.KeyAlgorithm$Ec(
      name,
      (algorithm as EcAlgorithm).namedCurve,
    );
  }

  if ("modulusLength" in algorithm) {
    const rsa = algorithm as RsaAlgorithm;
    return $keyAlgorithm.KeyAlgorithm$Rsa(
      name,
      rsa.modulusLength,
      new Uint8Array(rsa.publicExponent),
      hashName(rsa.hash),
    );
  }

  if ("hash" in algorithm) {
    const hmac = algorithm as HmacAlgorithm;
    return $keyAlgorithm.KeyAlgorithm$Hmac(
      name,
      hashName(hmac.hash),
      hmac.length,
    );
  }

  return $keyAlgorithm.KeyAlgorithm$Aes(
    name,
    (algorithm as AesAlgorithm).length,
  );
}
