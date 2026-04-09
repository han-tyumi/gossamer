import * as $ea from "$/gossamer/gossamer/ec_algorithm.mjs";

export function toEcAlgorithm(value: $ea.EcAlgorithm$): string {
  if ($ea.EcAlgorithm$isEcdh(value)) return "ECDH";
  if ($ea.EcAlgorithm$isOther(value)) return $ea.EcAlgorithm$Other$0(value);
  return "ECDSA";
}

export function fromEcAlgorithm(value: string): $ea.EcAlgorithm$ {
  switch (value) {
    case "ECDH":
      return $ea.EcAlgorithm$Ecdh();
    case "ECDSA":
      return $ea.EcAlgorithm$Ecdsa();
    default:
      return $ea.EcAlgorithm$Other(value);
  }
}
