import * as $binaryType from "$/gossamer/gossamer/binary_type.mjs";

export function toBinaryType(
  value: BinaryType,
): $binaryType.BinaryType$ {
  switch (value) {
    case "arraybuffer":
      return $binaryType.BinaryType$ArrayBuffer();
    case "blob":
      return $binaryType.BinaryType$Blob();
  }
}

export function fromBinaryType(
  value: $binaryType.BinaryType$,
): BinaryType {
  if ($binaryType.BinaryType$isArrayBuffer(value)) {
    return "arraybuffer";
  }
  return "blob";
}
