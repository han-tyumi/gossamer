import {
  type BitArray,
  BitArray$BitArray,
  BitArray$BitArray$data,
  type Result,
} from "$/prelude.mjs";
import { pad_to_bytes } from "$/gleam_stdlib/gleam/bit_array.mjs";
import { toResult } from "~/utils/result.ffi.ts";

/**
 * Returns the bytes of a `BitArray` typed as `BufferSource` for passing
 * to Web APIs. Un-aligned bit arrays are zero-padded to the next byte.
 */
export function toBufferSource(bitArray: BitArray): BufferSource {
  // @ts-expect-error denoland/deno#32063
  return BitArray$BitArray$data(pad_to_bytes(bitArray));
}

/**
 * Returns the bytes of a `BitArray` as a `Uint8Array` view. Un-aligned
 * bit arrays are zero-padded to the next byte.
 */
export function toUint8Array(bitArray: BitArray): Uint8Array {
  const view = BitArray$BitArray$data(pad_to_bytes(bitArray));
  return new Uint8Array(view.buffer, view.byteOffset, view.byteLength);
}

/**
 * Awaits an `ArrayBuffer`-returning Web API call and wraps the result
 * as a `BitArray` Result. Sync throws inside `fn` become `Error` rather
 * than unhandled FFI panics.
 */
export function toBitArrayResult(
  fn: () => Promise<ArrayBuffer>,
): Promise<Result<BitArray, Error>> {
  return toResult.fromAsync(async () =>
    BitArray$BitArray(new Uint8Array(await fn()))
  );
}

/**
 * Awaits a `Uint8Array`-returning Web API call and wraps the result as
 * a `BitArray` Result. Sync throws inside `fn` become `Error` rather
 * than unhandled FFI panics.
 */
export function toBitArrayBytesResult(
  fn: () => Promise<Uint8Array>,
): Promise<Result<BitArray, Error>> {
  return toResult.fromAsync(async () => BitArray$BitArray(await fn()));
}

/**
 * Wraps a `ReadableStream<Uint8Array>` so each chunk is read as a
 * `BitArray`.
 */
export function toBitArrayStream(
  source: ReadableStream<Uint8Array>,
): ReadableStream<BitArray> {
  return source.pipeThrough(
    new TransformStream<Uint8Array, BitArray>({
      transform(chunk, controller) {
        controller.enqueue(BitArray$BitArray(chunk));
      },
    }),
  );
}

/**
 * Wraps a `WritableStream<BufferSource>` so callers write `BitArray`
 * chunks. Errors on the underlying stream propagate through the
 * returned writable.
 */
export function fromBitArrayStream(
  target: WritableStream<BufferSource>,
): WritableStream<BitArray> {
  const transform = new TransformStream<BitArray, BufferSource>({
    transform(chunk, controller) {
      controller.enqueue(toBufferSource(chunk));
    },
  });
  transform.readable.pipeTo(target).catch(() => {});
  return transform.writable;
}

/**
 * Unwraps a `ReadableStream<BitArray>` to a `ReadableStream<Uint8Array>`
 * so chunks can be passed to Web APIs that expect byte streams.
 * Un-aligned chunks are zero-padded to the next byte.
 */
export function fromBitArrayReadable(
  source: ReadableStream<BitArray>,
): ReadableStream<Uint8Array> {
  return source.pipeThrough(
    new TransformStream<BitArray, Uint8Array>({
      transform(chunk, controller) {
        controller.enqueue(toUint8Array(chunk));
      },
    }),
  );
}
