import * as $jwk from "$/gossamer/gossamer/crypto/jwk.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import { fromKeyUsage, toKeyUsageArray } from "~/gossamer/crypto/key.ffi.ts";
import { fromArrayMapped } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";

type JWK = $jwk.JsonWebKey$;

function unwrap<T>(option: $option.Option$<T>): T | undefined {
  return $option.Option$isSome(option)
    ? ($option.Option$Some$0(option) as T)
    : undefined;
}

export function toJsonWebKey(jwk: JWK): JsonWebKey {
  const result: JsonWebKey = {};

  const kty = unwrap($jwk.JsonWebKey$JsonWebKey$kty(jwk));
  if (kty !== undefined) result.kty = kty;

  const use_ = unwrap($jwk.JsonWebKey$JsonWebKey$use_(jwk));
  if (use_ !== undefined) result.use = use_;

  const keyOps = unwrap($jwk.JsonWebKey$JsonWebKey$key_ops(jwk));
  if (keyOps !== undefined) {
    result.key_ops = toKeyUsageArray(keyOps) as string[];
  }

  const alg = unwrap($jwk.JsonWebKey$JsonWebKey$alg(jwk));
  if (alg !== undefined) result.alg = alg;

  const ext = unwrap($jwk.JsonWebKey$JsonWebKey$ext(jwk));
  if (ext !== undefined) result.ext = ext;

  const crv = unwrap($jwk.JsonWebKey$JsonWebKey$crv(jwk));
  if (crv !== undefined) result.crv = crv;

  const x = unwrap($jwk.JsonWebKey$JsonWebKey$x(jwk));
  if (x !== undefined) result.x = x;

  const y = unwrap($jwk.JsonWebKey$JsonWebKey$y(jwk));
  if (y !== undefined) result.y = y;

  const d = unwrap($jwk.JsonWebKey$JsonWebKey$d(jwk));
  if (d !== undefined) result.d = d;

  const n = unwrap($jwk.JsonWebKey$JsonWebKey$n(jwk));
  if (n !== undefined) result.n = n;

  const e = unwrap($jwk.JsonWebKey$JsonWebKey$e(jwk));
  if (e !== undefined) result.e = e;

  const p = unwrap($jwk.JsonWebKey$JsonWebKey$p(jwk));
  if (p !== undefined) result.p = p;

  const q = unwrap($jwk.JsonWebKey$JsonWebKey$q(jwk));
  if (q !== undefined) result.q = q;

  const dp = unwrap($jwk.JsonWebKey$JsonWebKey$dp(jwk));
  if (dp !== undefined) result.dp = dp;

  const dq = unwrap($jwk.JsonWebKey$JsonWebKey$dq(jwk));
  if (dq !== undefined) result.dq = dq;

  const qi = unwrap($jwk.JsonWebKey$JsonWebKey$qi(jwk));
  if (qi !== undefined) result.qi = qi;

  const k = unwrap($jwk.JsonWebKey$JsonWebKey$k(jwk));
  if (k !== undefined) result.k = k;

  return result;
}

export function fromJsonWebKey(jwk: JsonWebKey): JWK {
  return $jwk.JsonWebKey$JsonWebKey(
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
