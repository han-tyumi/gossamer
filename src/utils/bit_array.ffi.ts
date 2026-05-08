import {
  type BitArray,
  BitArray$BitArray,
  BitArray$BitArray$data,
  type Result,
} from "$/prelude.mjs";
import { toResult } from "~/utils/result.ffi.ts";

/**
 * Returns the bytes of a `BitArray` typed as `BufferSource` for passing
 * to Web APIs. Throws if the `BitArray` is not byte-aligned.
 */
export function toBufferSource(bitArray: BitArray): BufferSource {
  // @ts-expect-error denoland/deno#32063
  return BitArray$BitArray$data(bitArray);
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
