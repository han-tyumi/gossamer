import type * as $dataView from "$/gossamer/gossamer/buffer/data_view.mjs";
import * as $buffer from "$/gossamer/gossamer/buffer.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { checkViewDetached, checkViewRange } from "~/utils/buffer_check.ffi.ts";

export const new_: typeof $dataView.new$ = (buffer) => {
  if (buffer.detached) return Result$Error($buffer.BufferError$Detached());
  return Result$Ok(new DataView(buffer));
};

export const new_range: typeof $dataView.new_range = (
  buffer,
  byteOffset,
  byteLength,
) => {
  if (buffer.detached) return Result$Error($buffer.BufferError$Detached());
  if (byteOffset < 0 || byteOffset + byteLength > buffer.byteLength) {
    return Result$Error(
      $buffer.BufferError$OutOfRange(
        byteOffset + byteLength,
        buffer.byteLength,
      ),
    );
  }
  return Result$Ok(new DataView(buffer, byteOffset, byteLength));
};

export const buffer: typeof $dataView.buffer = (view) =>
  view.buffer as ArrayBuffer;

export const bytes: typeof $dataView.bytes = (view) =>
  checkViewDetached(
    view,
    () => new Uint8Array(view.buffer, view.byteOffset, view.byteLength),
  );

export const byte_length: typeof $dataView.byte_length = (view) =>
  checkViewDetached(view, () => view.byteLength);

export const byte_offset: typeof $dataView.byte_offset = (view) =>
  checkViewDetached(view, () => view.byteOffset);

export const get_int8: typeof $dataView.get_int8 = (view, offset) =>
  checkViewRange(view, offset, 1, () => view.getInt8(offset));

export const get_uint8: typeof $dataView.get_uint8 = (view, offset) =>
  checkViewRange(view, offset, 1, () => view.getUint8(offset));

export const get_int16: typeof $dataView.get_int16 = (
  view,
  offset,
  littleEndian,
) => checkViewRange(view, offset, 2, () => view.getInt16(offset, littleEndian));

export const get_uint16: typeof $dataView.get_uint16 = (
  view,
  offset,
  littleEndian,
) =>
  checkViewRange(view, offset, 2, () => view.getUint16(offset, littleEndian));

export const get_int32: typeof $dataView.get_int32 = (
  view,
  offset,
  littleEndian,
) => checkViewRange(view, offset, 4, () => view.getInt32(offset, littleEndian));

export const get_uint32: typeof $dataView.get_uint32 = (
  view,
  offset,
  littleEndian,
) =>
  checkViewRange(view, offset, 4, () => view.getUint32(offset, littleEndian));

export const get_float16: typeof $dataView.get_float16 = (
  view,
  offset,
  littleEndian,
) =>
  checkViewRange(view, offset, 2, () => view.getFloat16(offset, littleEndian));

export const get_float32: typeof $dataView.get_float32 = (
  view,
  offset,
  littleEndian,
) =>
  checkViewRange(view, offset, 4, () => view.getFloat32(offset, littleEndian));

export const get_float64: typeof $dataView.get_float64 = (
  view,
  offset,
  littleEndian,
) =>
  checkViewRange(view, offset, 8, () => view.getFloat64(offset, littleEndian));

export const get_bigint64: typeof $dataView.get_bigint64 = (
  view,
  offset,
  littleEndian,
) =>
  checkViewRange(view, offset, 8, () => view.getBigInt64(offset, littleEndian));

export const get_biguint64: typeof $dataView.get_biguint64 = (
  view,
  offset,
  littleEndian,
) =>
  checkViewRange(
    view,
    offset,
    8,
    () => view.getBigUint64(offset, littleEndian),
  );

export const set_int8: typeof $dataView.set_int8 = (view, offset, value) =>
  checkViewRange(view, offset, 1, () => {
    view.setInt8(offset, value);
  });

export const set_uint8: typeof $dataView.set_uint8 = (view, offset, value) =>
  checkViewRange(view, offset, 1, () => {
    view.setUint8(offset, value);
  });

export const set_int16: typeof $dataView.set_int16 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 2, () => {
    view.setInt16(offset, value, littleEndian);
  });

export const set_uint16: typeof $dataView.set_uint16 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 2, () => {
    view.setUint16(offset, value, littleEndian);
  });

export const set_int32: typeof $dataView.set_int32 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 4, () => {
    view.setInt32(offset, value, littleEndian);
  });

export const set_uint32: typeof $dataView.set_uint32 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 4, () => {
    view.setUint32(offset, value, littleEndian);
  });

export const set_float16: typeof $dataView.set_float16 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 2, () => {
    view.setFloat16(offset, value, littleEndian);
  });

export const set_float32: typeof $dataView.set_float32 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 4, () => {
    view.setFloat32(offset, value, littleEndian);
  });

export const set_float64: typeof $dataView.set_float64 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 8, () => {
    view.setFloat64(offset, value, littleEndian);
  });

export const set_bigint64: typeof $dataView.set_bigint64 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 8, () => {
    view.setBigInt64(offset, value, littleEndian);
  });

export const set_biguint64: typeof $dataView.set_biguint64 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  checkViewRange(view, offset, 8, () => {
    view.setBigUint64(offset, value, littleEndian);
  });
