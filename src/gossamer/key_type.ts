import * as $keyType from "$/gossamer/gossamer/key_type.mjs";

export function toKeyType(value: KeyType | string): $keyType.KeyType$ {
  switch (value) {
    case "private":
      return $keyType.KeyType$Private();
    case "public":
      return $keyType.KeyType$Public();
    case "secret":
      return $keyType.KeyType$Secret();
    default:
      return $keyType.KeyType$Other(value);
  }
}
