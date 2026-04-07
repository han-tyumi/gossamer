import * as $arrayBufferView from "$/gossamer/gossamer/array_buffer_view.mjs";

export function toArrayBufferViewType(
  view: ArrayBufferView & { buffer: ArrayBuffer },
) {
  return $arrayBufferView.ArrayBufferView$ArrayBufferView(
    view.buffer,
    view.byteLength,
    view.byteOffset,
  );
}
