import * as $keyFormat from "$/gossamer/gossamer/key_format.mjs";

export function toKeyFormat(
  value: $keyFormat.KeyFormat$,
): Exclude<KeyFormat, "jwk"> {
  if ($keyFormat.KeyFormat$isPkcs8(value)) return "pkcs8";
  if ($keyFormat.KeyFormat$isRaw(value)) return "raw";
  return "spki";
}
