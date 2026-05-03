import * as $typedArray from "$/gossamer/gossamer/typed_array.mjs";

type AnyTypedArray =
  | Int8Array<ArrayBufferLike>
  | Uint8Array<ArrayBufferLike>
  | Uint8ClampedArray<ArrayBufferLike>
  | Int16Array<ArrayBufferLike>
  | Uint16Array<ArrayBufferLike>
  | Int32Array<ArrayBufferLike>
  | Uint32Array<ArrayBufferLike>
  | Float16Array<ArrayBufferLike>
  | Float32Array<ArrayBufferLike>
  | Float64Array<ArrayBufferLike>
  | BigInt64Array<ArrayBufferLike>
  | BigUint64Array<ArrayBufferLike>;

/**
 * Unwrap a `TypedArray` Gleam variant to its underlying JS typed array.
 * Used at every FFI boundary that passes a `TypedArray` into a JS API.
 */
export function unwrap(typed: $typedArray.TypedArray$): AnyTypedArray {
  if ($typedArray.TypedArray$isInt8(typed)) {
    return $typedArray.TypedArray$Int8$0(typed);
  }
  if ($typedArray.TypedArray$isUint8(typed)) {
    return $typedArray.TypedArray$Uint8$0(typed);
  }
  if ($typedArray.TypedArray$isUint8Clamped(typed)) {
    return $typedArray.TypedArray$Uint8Clamped$0(typed);
  }
  if ($typedArray.TypedArray$isInt16(typed)) {
    return $typedArray.TypedArray$Int16$0(typed);
  }
  if ($typedArray.TypedArray$isUint16(typed)) {
    return $typedArray.TypedArray$Uint16$0(typed);
  }
  if ($typedArray.TypedArray$isInt32(typed)) {
    return $typedArray.TypedArray$Int32$0(typed);
  }
  if ($typedArray.TypedArray$isUint32(typed)) {
    return $typedArray.TypedArray$Uint32$0(typed);
  }
  if ($typedArray.TypedArray$isFloat16(typed)) {
    return $typedArray.TypedArray$Float16$0(typed);
  }
  if ($typedArray.TypedArray$isFloat32(typed)) {
    return $typedArray.TypedArray$Float32$0(typed);
  }
  if ($typedArray.TypedArray$isFloat64(typed)) {
    return $typedArray.TypedArray$Float64$0(typed);
  }
  if ($typedArray.TypedArray$isBigInt64(typed)) {
    return $typedArray.TypedArray$BigInt64$0(typed);
  }
  return $typedArray.TypedArray$BigUint64$0(typed);
}

/**
 * Wrap a JS typed array as the matching `TypedArray` Gleam variant.
 * Used at every FFI boundary that returns a `TypedArray` to Gleam.
 */
export function wrap(arr: AnyTypedArray): $typedArray.TypedArray$ {
  if (arr instanceof Int8Array) return $typedArray.TypedArray$Int8(arr);
  if (arr instanceof Uint8ClampedArray) {
    return $typedArray.TypedArray$Uint8Clamped(arr);
  }
  if (arr instanceof Uint8Array) return $typedArray.TypedArray$Uint8(arr);
  if (arr instanceof Int16Array) return $typedArray.TypedArray$Int16(arr);
  if (arr instanceof Uint16Array) return $typedArray.TypedArray$Uint16(arr);
  if (arr instanceof Int32Array) return $typedArray.TypedArray$Int32(arr);
  if (arr instanceof Uint32Array) return $typedArray.TypedArray$Uint32(arr);
  if (arr instanceof Float16Array) return $typedArray.TypedArray$Float16(arr);
  if (arr instanceof Float32Array) return $typedArray.TypedArray$Float32(arr);
  if (arr instanceof Float64Array) return $typedArray.TypedArray$Float64(arr);
  if (arr instanceof BigInt64Array) return $typedArray.TypedArray$BigInt64(arr);
  return $typedArray.TypedArray$BigUint64(arr as BigUint64Array);
}

export const length: typeof $typedArray.length = (typed) =>
  unwrap(typed).length;

export const byte_length: typeof $typedArray.byte_length = (typed) =>
  unwrap(typed).byteLength;

export const byte_offset: typeof $typedArray.byte_offset = (typed) =>
  unwrap(typed).byteOffset;

export const buffer: typeof $typedArray.buffer = (typed) =>
  unwrap(typed).buffer as ArrayBuffer;
