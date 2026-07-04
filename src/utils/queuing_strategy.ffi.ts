import { byte_size } from "$/gleam_stdlib/gleam/bit_array.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { type BitArray, BitArray$isBitArray } from "$/prelude.mjs";

export function fromQueuingStrategy(
  strategy: $stream.QueuingStrategy$,
): QueuingStrategy {
  if ($stream.QueuingStrategy$isUnlimited(strategy)) {
    return new CountQueuingStrategy({ highWaterMark: Infinity });
  }
  if ($stream.QueuingStrategy$isByCount(strategy)) {
    return new CountQueuingStrategy({
      highWaterMark: $stream.QueuingStrategy$ByCount$high_water_mark(strategy),
    });
  }
  // ByteLengthQueuingStrategy sizes chunks via chunk.byteLength, which a
  // Gleam BitArray doesn't have, so measure BitArray chunks explicitly.
  return {
    highWaterMark: $stream.QueuingStrategy$ByByteLength$high_water_mark(
      strategy,
    ),
    size: (chunk: BitArray | ArrayBufferView | ArrayBuffer) =>
      BitArray$isBitArray(chunk) ? byte_size(chunk) : chunk.byteLength,
  };
}
