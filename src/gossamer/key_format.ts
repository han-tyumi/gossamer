import * as $keyFormat from "$/gossamer/gossamer/key_format.mjs";

export function toKeyFormat(
  value: $keyFormat.KeyFormat$,
): Exclude<KeyFormat, "jwk"> {
  if ($keyFormat.KeyFormat$isPkcs8(value)) return "pkcs8";
  if ($keyFormat.KeyFormat$isRaw(value)) return "raw";
  if ($keyFormat.KeyFormat$isOther(value)) {
    return $keyFormat.KeyFormat$Other$0(value) as Exclude<KeyFormat, "jwk">;
  }
  return "spki";
}
