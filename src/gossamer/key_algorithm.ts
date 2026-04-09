import * as $keyAlgorithm from "$/gossamer/gossamer/key_algorithm.mjs";
import { fromAesAlgorithm } from "~/gossamer/aes_algorithm.ts";
import { fromEcAlgorithm } from "~/gossamer/ec_algorithm.ts";
import { fromHashAlgorithm } from "~/gossamer/hash_algorithm.ts";
import { fromNamedCurve } from "~/gossamer/named_curve.ts";
import { fromRsaAlgorithm } from "~/gossamer/rsa_algorithm.ts";

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
      fromEcAlgorithm(name),
      fromNamedCurve((algorithm as EcAlgorithm).namedCurve),
    );
  }

  if ("modulusLength" in algorithm) {
    const rsa = algorithm as RsaAlgorithm;
    return $keyAlgorithm.KeyAlgorithm$Rsa(
      fromRsaAlgorithm(name),
      rsa.modulusLength,
      new Uint8Array(rsa.publicExponent),
      fromHashAlgorithm(hashName(rsa.hash)),
    );
  }

  if ("hash" in algorithm) {
    const hmac = algorithm as HmacAlgorithm;
    return $keyAlgorithm.KeyAlgorithm$Hmac(
      fromHashAlgorithm(hashName(hmac.hash)),
      hmac.length,
    );
  }

  return $keyAlgorithm.KeyAlgorithm$Aes(
    fromAesAlgorithm(name),
    (algorithm as AesAlgorithm).length,
  );
}
