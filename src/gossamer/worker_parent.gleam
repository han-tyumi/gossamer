//// Helpers a worker script uses to communicate with its parent
//// thread. Import this from your worker module to send and receive
//// messages without runtime-specific code.
////
//// Pair with [`gossamer/worker`](./worker.html) on the parent side.
////
//// ## Sending Gleam values
////
//// Values cross via structured-clone and arrive on the parent side as
//// `Dynamic`. See [`gossamer/message_port`](./message_port.html) for
//// what round-trips cleanly and how to decode the received data.
////
//// ## Transferring ports
////
//// A [`MessagePort`](./message_port.html) reachable from the data
//// passed to [`post_message`](#post_message) is automatically detached
//// on this side and re-attached on the parent — the message and any
//// ports ride a single atomic call. Transferred ports are no longer
//// usable on the sender. To extract a transferred port from the
//// received `Dynamic`, use
//// [`message_port.from_dynamic`](./message_port.html#from_dynamic).

import gleam/dynamic.{type Dynamic}

/// Sends `data` back to the parent thread. Any
/// [`MessagePort`](./message_port.html) reachable from `data` is
/// detached on this side and arrives on the parent at its position in
/// the data structure. Returns an error if `data` can't be serialized
/// by the structured-clone algorithm — functions, symbols, and most
/// class instances are not cloneable. Equivalent to JavaScript's
/// `self.postMessage` inside a Worker (or `parentPort.postMessage`
/// inside `node:worker_threads`).
///
@external(javascript, "./worker_parent.ffi.mjs", "post_message")
pub fn post_message(data: a) -> Result(Nil, Nil)

/// Registers a handler invoked for each message the parent sends.
/// Decode the payload with `gleam/dynamic/decode`; extract any
/// transferred ports with
/// [`message_port.from_dynamic`](./message_port.html#from_dynamic).
/// `ArrayBuffer` payloads are wrapped as `BitArray`; other values pass
/// through unchanged. Equivalent to JavaScript's `self.onmessage`
/// inside a Worker (or `parentPort.onmessage` inside
/// `node:worker_threads`).
///
@external(javascript, "./worker_parent.ffi.mjs", "set_on_message")
pub fn set_on_message(handler: fn(Dynamic) -> a) -> Nil
