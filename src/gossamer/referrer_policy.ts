import * as $rp from "$/gossamer/gossamer/referrer_policy.mjs";

export function fromReferrerPolicy(value: string): $rp.ReferrerPolicy$ {
  switch (value) {
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
    case "strict-origin-when-cross-origin":
      return $rp.ReferrerPolicy$StrictOriginWhenCrossOrigin();
    case "unsafe-url":
      return $rp.ReferrerPolicy$UnsafeUrl();
    default:
      return $rp.ReferrerPolicy$Other(value);
  }
}
