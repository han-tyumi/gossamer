import * as $pair from "$/gossamer/gossamer/crypto_key_pair.mjs";

export function toCryptoKeyPair(
  pair: CryptoKeyPair,
): $pair.CryptoKeyPair$ {
  return $pair.CryptoKeyPair$CryptoKeyPair(pair.publicKey, pair.privateKey);
}
