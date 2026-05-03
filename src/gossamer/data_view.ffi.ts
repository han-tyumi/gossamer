import type * as $dataView from "$/gossamer/gossamer/data_view.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $dataView.new$ = (buffer) =>
  toResult.fromThrows(() => new DataView(buffer));

export const new_range: typeof $dataView.new_range = (
  buffer,
  byteOffset,
  byteLength,
) => toResult.fromThrows(() => new DataView(buffer, byteOffset, byteLength));

export const buffer: typeof $dataView.buffer = (view) =>
  view.buffer as ArrayBuffer;

export const byte_length: typeof $dataView.byte_length = (view) =>
  toResult.fromThrows(() => view.byteLength);

export const byte_offset: typeof $dataView.byte_offset = (view) =>
  toResult.fromThrows(() => view.byteOffset);

export const get_int8: typeof $dataView.get_int8 = (view, offset) =>
  toResult.fromThrows(() => view.getInt8(offset));

export const get_uint8: typeof $dataView.get_uint8 = (view, offset) =>
  toResult.fromThrows(() => view.getUint8(offset));

export const get_int16: typeof $dataView.get_int16 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getInt16(offset, littleEndian));

export const get_uint16: typeof $dataView.get_uint16 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getUint16(offset, littleEndian));

export const get_int32: typeof $dataView.get_int32 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getInt32(offset, littleEndian));

export const get_uint32: typeof $dataView.get_uint32 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getUint32(offset, littleEndian));

export const get_float16: typeof $dataView.get_float16 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getFloat16(offset, littleEndian));

export const get_float32: typeof $dataView.get_float32 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getFloat32(offset, littleEndian));

export const get_float64: typeof $dataView.get_float64 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getFloat64(offset, littleEndian));

export const get_bigint64: typeof $dataView.get_bigint64 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getBigInt64(offset, littleEndian));

export const get_biguint64: typeof $dataView.get_biguint64 = (
  view,
  offset,
  littleEndian,
) => toResult.fromThrows(() => view.getBigUint64(offset, littleEndian));

export const set_int8: typeof $dataView.set_int8 = (view, offset, value) =>
  toResult.fromThrows(() => {
    view.setInt8(offset, value);
    return undefined;
  });

export const set_uint8: typeof $dataView.set_uint8 = (view, offset, value) =>
  toResult.fromThrows(() => {
    view.setUint8(offset, value);
    return undefined;
  });

export const set_int16: typeof $dataView.set_int16 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setInt16(offset, value, littleEndian);
    return undefined;
  });

export const set_uint16: typeof $dataView.set_uint16 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setUint16(offset, value, littleEndian);
    return undefined;
  });

export const set_int32: typeof $dataView.set_int32 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setInt32(offset, value, littleEndian);
    return undefined;
  });

export const set_uint32: typeof $dataView.set_uint32 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setUint32(offset, value, littleEndian);
    return undefined;
  });

export const set_float16: typeof $dataView.set_float16 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setFloat16(offset, value, littleEndian);
    return undefined;
  });

export const set_float32: typeof $dataView.set_float32 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setFloat32(offset, value, littleEndian);
    return undefined;
  });

export const set_float64: typeof $dataView.set_float64 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setFloat64(offset, value, littleEndian);
    return undefined;
  });

export const set_bigint64: typeof $dataView.set_bigint64 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setBigInt64(offset, value, littleEndian);
    return undefined;
  });

export const set_biguint64: typeof $dataView.set_biguint64 = (
  view,
  offset,
  value,
  littleEndian,
) =>
  toResult.fromThrows(() => {
    view.setBigUint64(offset, value, littleEndian);
    return undefined;
  });
