import type * as $workerParent from "$/gossamer/gossamer/worker_parent.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  unwrapBitArrayForClone,
  wrapArrayBuffer,
} from "~/utils/bit_array.ffi.ts";

// On Deno, Bun, and Node, `node:worker_threads` is reachable (Deno and
// Bun ship a compatibility shim). `parentPort` is non-null inside a
// worker thread on all three. In browsers, the import fails -- fall
// back to the Web Worker globals on `self`.
// deno-lint-ignore no-explicit-any
let parentPort: any = null;
try {
  parentPort = (await import("node:worker_threads")).parentPort;
} catch {
  parentPort = null;
}

interface Target {
  postMessage(data: unknown): void;
}

const target: Target = parentPort ?? (globalThis as unknown as Target);

function onMessage(handler: (data: unknown) => void): void {
  if (parentPort) {
    parentPort.onmessage = (event: MessageEvent) => handler(event.data);
  } else {
    // @ts-expect-error onmessage is a global in a Web Worker scope.
    globalThis.onmessage = (event: MessageEvent) => handler(event.data);
  }
}

export const post_message: typeof $workerParent.post_message = (data) => {
  try {
    target.postMessage(unwrapBitArrayForClone(data));
    return Result$Ok(undefined);
  } catch {
    return Result$Error(undefined);
  }
};

export const set_on_message: typeof $workerParent.set_on_message = (
  handler,
) => {
  onMessage((data: unknown) => handler(wrapArrayBuffer(data)));
};
