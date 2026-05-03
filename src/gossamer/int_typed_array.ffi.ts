import * as $intTypedArray from "$/gossamer/gossamer/int_typed_array.mjs";

type AnyIntTypedArray =
  | Int8Array<ArrayBufferLike>
  | Uint8Array<ArrayBufferLike>
  | Uint8ClampedArray<ArrayBufferLike>
  | Int16Array<ArrayBufferLike>
  | Uint16Array<ArrayBufferLike>
  | Int32Array<ArrayBufferLike>
  | Uint32Array<ArrayBufferLike>
  | BigInt64Array<ArrayBufferLike>
  | BigUint64Array<ArrayBufferLike>;

/**
 * Unwrap an `IntTypedArray` Gleam variant to its underlying JS typed array.
 * Used at every FFI boundary that passes an `IntTypedArray` into a JS API.
 */
export function unwrap(
  intTyped: $intTypedArray.IntTypedArray$,
): AnyIntTypedArray {
  if ($intTypedArray.IntTypedArray$isInt8(intTyped)) {
    return $intTypedArray.IntTypedArray$Int8$0(intTyped);
  }
  if ($intTypedArray.IntTypedArray$isUint8(intTyped)) {
    return $intTypedArray.IntTypedArray$Uint8$0(intTyped);
  }
  if ($intTypedArray.IntTypedArray$isUint8Clamped(intTyped)) {
    return $intTypedArray.IntTypedArray$Uint8Clamped$0(intTyped);
  }
  if ($intTypedArray.IntTypedArray$isInt16(intTyped)) {
    return $intTypedArray.IntTypedArray$Int16$0(intTyped);
  }
  if ($intTypedArray.IntTypedArray$isUint16(intTyped)) {
    return $intTypedArray.IntTypedArray$Uint16$0(intTyped);
  }
  if ($intTypedArray.IntTypedArray$isInt32(intTyped)) {
    return $intTypedArray.IntTypedArray$Int32$0(intTyped);
  }
  if ($intTypedArray.IntTypedArray$isUint32(intTyped)) {
    return $intTypedArray.IntTypedArray$Uint32$0(intTyped);
  }
  if ($intTypedArray.IntTypedArray$isBigInt64(intTyped)) {
    return $intTypedArray.IntTypedArray$BigInt64$0(intTyped);
  }
  return $intTypedArray.IntTypedArray$BigUint64$0(intTyped);
}

/**
 * Wrap a JS integer typed array as the matching `IntTypedArray` Gleam variant.
 * Used at every FFI boundary that returns an `IntTypedArray` to Gleam.
 */
export function wrap(arr: AnyIntTypedArray): $intTypedArray.IntTypedArray$ {
  if (arr instanceof Int8Array) return $intTypedArray.IntTypedArray$Int8(arr);
  if (arr instanceof Uint8ClampedArray) {
    return $intTypedArray.IntTypedArray$Uint8Clamped(arr);
  }
  if (arr instanceof Uint8Array) return $intTypedArray.IntTypedArray$Uint8(arr);
  if (arr instanceof Int16Array) return $intTypedArray.IntTypedArray$Int16(arr);
  if (arr instanceof Uint16Array) {
    return $intTypedArray.IntTypedArray$Uint16(arr);
  }
  if (arr instanceof Int32Array) return $intTypedArray.IntTypedArray$Int32(arr);
  if (arr instanceof Uint32Array) {
    return $intTypedArray.IntTypedArray$Uint32(arr);
  }
  if (arr instanceof BigInt64Array) {
    return $intTypedArray.IntTypedArray$BigInt64(arr);
  }
  return $intTypedArray.IntTypedArray$BigUint64(arr as BigUint64Array);
}
