import * as $nc from "$/gossamer/gossamer/named_curve.mjs";

export function toNamedCurve(value: $nc.NamedCurve$): string {
  if ($nc.NamedCurve$isP256(value)) return "P-256";
  if ($nc.NamedCurve$isP384(value)) return "P-384";
  if ($nc.NamedCurve$isOther(value)) return $nc.NamedCurve$Other$0(value);
  return "P-521";
}

export function fromNamedCurve(value: string): $nc.NamedCurve$ {
  switch (value) {
    case "P-256":
      return $nc.NamedCurve$P256();
    case "P-384":
      return $nc.NamedCurve$P384();
    case "P-521":
      return $nc.NamedCurve$P521();
    default:
      return $nc.NamedCurve$Other(value);
  }
}
