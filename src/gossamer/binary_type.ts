import * as $binaryType from "$/gossamer/gossamer/binary_type.mjs";

export function toBinaryType(
  value: BinaryType | string,
): $binaryType.BinaryType$ {
  switch (value) {
    case "arraybuffer":
      return $binaryType.BinaryType$ArrayBuffer();
    case "blob":
      return $binaryType.BinaryType$Blob();
    default:
      return $binaryType.BinaryType$Other(value);
  }
}

export function fromBinaryType(
  value: $binaryType.BinaryType$,
): BinaryType {
  if ($binaryType.BinaryType$isArrayBuffer(value)) return "arraybuffer";
  if ($binaryType.BinaryType$isOther(value)) {
    return $binaryType.BinaryType$Other$0(value) as BinaryType;
  }
  return "blob";
}
