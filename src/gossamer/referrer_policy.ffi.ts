import * as $rp from "$/gossamer/gossamer/referrer_policy.mjs";

export function toReferrerPolicy(value: $rp.ReferrerPolicy$): string {
  if ($rp.ReferrerPolicy$isNoReferrer(value)) return "no-referrer";
  if ($rp.ReferrerPolicy$isNoReferrerWhenDowngrade(value)) {
    return "no-referrer-when-downgrade";
  }
  if ($rp.ReferrerPolicy$isOrigin(value)) return "origin";
  if ($rp.ReferrerPolicy$isOriginWhenCrossOrigin(value)) {
    return "origin-when-cross-origin";
  }
  if ($rp.ReferrerPolicy$isSameOrigin(value)) return "same-origin";
  if ($rp.ReferrerPolicy$isStrictOrigin(value)) return "strict-origin";
  if ($rp.ReferrerPolicy$isUnsafeUrl(value)) return "unsafe-url";
  if ($rp.ReferrerPolicy$isOther(value)) {
    return $rp.ReferrerPolicy$Other$0(value);
  }
  return "strict-origin-when-cross-origin";
}

export function fromReferrerPolicy(
  value: string | undefined,
): $rp.ReferrerPolicy$ {
  switch (value) {
    case undefined:
    case "":
    case "strict-origin-when-cross-origin":
      return $rp.ReferrerPolicy$StrictOriginWhenCrossOrigin();
    case "no-referrer":
      return $rp.ReferrerPolicy$NoReferrer();
    case "no-referrer-when-downgrade":
      return $rp.ReferrerPolicy$NoReferrerWhenDowngrade();
    case "origin":
      return $rp.ReferrerPolicy$Origin();
    case "origin-when-cross-origin":
      return $rp.ReferrerPolicy$OriginWhenCrossOrigin();
    case "same-origin":
      return $rp.ReferrerPolicy$SameOrigin();
    case "strict-origin":
      return $rp.ReferrerPolicy$StrictOrigin();
    case "unsafe-url":
      return $rp.ReferrerPolicy$UnsafeUrl();
    default:
      return $rp.ReferrerPolicy$Other(value);
  }
}
