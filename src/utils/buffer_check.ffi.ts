import * as $buffer from "$/gossamer/gossamer/buffer.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

type AnyTypedArray =
  | Int8Array
  | Uint8Array
  | Uint8ClampedArray
  | Int16Array
  | Uint16Array
  | Int32Array
  | Uint32Array
  | Float16Array
  | Float32Array
  | Float64Array
  | BigInt64Array
  | BigUint64Array;

export function checkArrayDetached<A extends AnyTypedArray, T>(
  array: A,
  op: () => T,
) {
  if ((array.buffer as ArrayBuffer).detached) {
    return Result$Error($buffer.BufferError$Detached());
  }
  return Result$Ok(op());
}

export function checkArrayRange<A extends AnyTypedArray, T>(
  array: A,
  index: number,
  length: number,
  op: () => T,
) {
  if ((array.buffer as ArrayBuffer).detached) {
    return Result$Error($buffer.BufferError$Detached());
  }
  if (index < 0 || index + length > array.length) {
    return Result$Error($buffer.BufferError$OutOfRange(index, array.length));
  }
  return Result$Ok(op());
}

export function checkBufferAligned<T>(
  buffer: ArrayBuffer,
  alignment: number,
  op: () => T,
) {
  if (buffer.detached) return Result$Error($buffer.BufferError$Detached());
  if (buffer.byteLength % alignment !== 0) {
    return Result$Error(
      $buffer.BufferError$MisalignedOffset(buffer.byteLength, alignment),
    );
  }
  return Result$Ok(op());
}

export function checkBufferRangeAligned<T>(
  buffer: ArrayBuffer,
  byteOffset: number,
  length: number,
  alignment: number,
  op: () => T,
) {
  if (buffer.detached) return Result$Error($buffer.BufferError$Detached());
  if (byteOffset % alignment !== 0) {
    return Result$Error(
      $buffer.BufferError$MisalignedOffset(byteOffset, alignment),
    );
  }
  const byteLength = length * alignment;
  if (byteOffset < 0 || byteOffset + byteLength > buffer.byteLength) {
    return Result$Error(
      $buffer.BufferError$OutOfRange(
        byteOffset + byteLength,
        buffer.byteLength,
      ),
    );
  }
  return Result$Ok(op());
}

export function checkViewDetached<T>(view: DataView, op: () => T) {
  if ((view.buffer as ArrayBuffer).detached) {
    return Result$Error($buffer.BufferError$Detached());
  }
  return Result$Ok(op());
}

export function checkViewRange<T>(
  view: DataView,
  offset: number,
  size: number,
  op: () => T,
) {
  if ((view.buffer as ArrayBuffer).detached) {
    return Result$Error($buffer.BufferError$Detached());
  }
  if (offset < 0 || offset + size > view.byteLength) {
    return Result$Error(
      $buffer.BufferError$OutOfRange(offset, view.byteLength),
    );
  }
  return Result$Ok(op());
}
