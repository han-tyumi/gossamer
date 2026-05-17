//// Helpers a worker script uses to communicate with its parent
//// thread. Import this from your worker module to send and receive
//// messages without runtime-specific code.
////
//// Pair with [`gossamer/worker`](./worker.html) on the parent side.

import gleam/dynamic.{type Dynamic}

/// Sends `data` back to the parent thread. Returns an error if `data`
/// can't be serialized by the structured-clone algorithm — functions,
/// symbols, and most class instances are not cloneable. Equivalent
/// to JavaScript's `self.postMessage` inside a Worker (or
/// `parentPort.postMessage` inside `node:worker_threads`).
///
@external(javascript, "./worker_parent.ffi.mjs", "post_message")
pub fn post_message(data: a) -> Result(Nil, Nil)

/// Registers a handler invoked for each message the parent sends. The
/// payload is exposed directly; `ArrayBuffer` values are wrapped as
/// `BitArray`, other values pass through unchanged. Decode with
/// `gleam/dynamic/decode`. Equivalent to JavaScript's `self.onmessage`
/// inside a Worker (or `parentPort.onmessage` inside
/// `node:worker_threads`).
///
@external(javascript, "./worker_parent.ffi.mjs", "set_on_message")
pub fn set_on_message(handler: fn(Dynamic) -> a) -> Nil
