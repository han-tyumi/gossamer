import * as $type from "$/gossamer/gossamer/subtle_crypto/derived_key_type.mjs";
import { toAesAlgorithm } from "~/gossamer/aes_algorithm.ffi.ts";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ffi.ts";

export function toDerivedKeyType(
  derivedKeyType: $type.DerivedKeyType$,
): AlgorithmIdentifier | AesDerivedKeyParams | HmacImportParams {
  if ($type.DerivedKeyType$isOther(derivedKeyType)) {
    return $type.DerivedKeyType$Other$0(derivedKeyType);
  }
  if ($type.DerivedKeyType$isAesDerived(derivedKeyType)) {
    return {
      name: toAesAlgorithm(
        $type.DerivedKeyType$AesDerived$name(derivedKeyType),
      ),
      length: $type.DerivedKeyType$AesDerived$length(derivedKeyType),
    };
  }
  return {
    name: "HMAC",
    hash: toHashAlgorithm(
      $type.DerivedKeyType$HmacDerived$hash(derivedKeyType),
    ),
  };
}
