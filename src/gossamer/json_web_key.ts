import * as $jsonWebKey from "$/gossamer/gossamer/json_web_key.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import { fromKeyUsage, toKeyUsageArray } from "~/gossamer/key_usage.ts";
import { fromArrayMapped } from "~/utils/list.ts";
import { toOption } from "~/utils/option.ts";

type JWK = $jsonWebKey.JsonWebKey$;

function unwrap<T>(option: $option.Option$<T>): T | undefined {
  return $option.Option$isSome(option)
    ? ($option.Option$Some$0(option) as T)
    : undefined;
}

export function toJsonWebKey(jwk: JWK): JsonWebKey {
  const result: JsonWebKey = {};

  const kty = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$kty(jwk));
  if (kty !== undefined) result.kty = kty;

  const use_ = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$use_(jwk));
  if (use_ !== undefined) result.use = use_;

  const keyOps = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$key_ops(jwk));
  if (keyOps !== undefined) {
    result.key_ops = toKeyUsageArray(keyOps) as string[];
  }

  const alg = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$alg(jwk));
  if (alg !== undefined) result.alg = alg;

  const ext = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$ext(jwk));
  if (ext !== undefined) result.ext = ext;

  const crv = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$crv(jwk));
  if (crv !== undefined) result.crv = crv;

  const x = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$x(jwk));
  if (x !== undefined) result.x = x;

  const y = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$y(jwk));
  if (y !== undefined) result.y = y;

  const d = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$d(jwk));
  if (d !== undefined) result.d = d;

  const n = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$n(jwk));
  if (n !== undefined) result.n = n;

  const e = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$e(jwk));
  if (e !== undefined) result.e = e;

  const p = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$p(jwk));
  if (p !== undefined) result.p = p;

  const q = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$q(jwk));
  if (q !== undefined) result.q = q;

  const dp = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$dp(jwk));
  if (dp !== undefined) result.dp = dp;

  const dq = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$dq(jwk));
  if (dq !== undefined) result.dq = dq;

  const qi = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$qi(jwk));
  if (qi !== undefined) result.qi = qi;

  const k = unwrap($jsonWebKey.JsonWebKey$JsonWebKey$k(jwk));
  if (k !== undefined) result.k = k;

  return result;
}

export function fromJsonWebKey(jwk: JsonWebKey): JWK {
  return $jsonWebKey.JsonWebKey$JsonWebKey(
    toOption(jwk.kty),
    toOption(jwk.use),
    jwk.key_ops !== undefined
      ? $option.Option$Some(
        fromArrayMapped(jwk.key_ops as KeyUsage[], fromKeyUsage),
      )
      : $option.Option$None(),
    toOption(jwk.alg),
    toOption(jwk.ext),
    toOption(jwk.crv),
    toOption(jwk.x),
    toOption(jwk.y),
    toOption(jwk.d),
    toOption(jwk.n),
    toOption(jwk.e),
    toOption(jwk.p),
    toOption(jwk.q),
    toOption(jwk.dp),
    toOption(jwk.dq),
    toOption(jwk.qi),
    toOption(jwk.k),
  );
}
