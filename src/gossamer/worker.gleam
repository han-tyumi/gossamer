//// A script running on a separate thread. The canonical path is to
//// write the worker as a Gleam module exporting `main()`, then spawn
//// it with [`from_module`](#from_module). Inside the worker script,
//// use [`gossamer/worker_parent`](./worker_parent.html) to communicate
//// with the parent thread. For non-Gleam scripts, [`new`](#new)
//// takes a script URL directly.
////
//// Send messages to a running worker with
//// [`post_message`](#post_message) and stop it with
//// [`terminate`](#terminate).

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option, None, Some}

/// A separate-thread script.
///
/// See [Worker](https://developer.mozilla.org/en-US/docs/Web/API/Worker) on MDN.
///
@external(javascript, "./worker.type.ts", "Worker$")
pub type Worker

/// The configuration for a [`Worker`](#Worker).
///
pub opaque type Builder {
  Builder(
    url: String,
    name: String,
    on_message: Option(fn(Worker, Dynamic) -> Nil),
  )
}

/// Creates a `Builder` for a worker that runs the ECMAScript module
/// at `url`. The name defaults to `""` and no message handler is
/// attached.
///
pub fn new(url: String) -> Builder {
  Builder(url:, name: "", on_message: None)
}

/// Creates a `Builder` for a worker that runs the `main()` function of
/// the named Gleam module. `name` is the qualified Gleam module name
/// — the same name used in `import` statements (for example,
/// `"my_app/worker"`). The first path segment is taken as the package
/// name, matching Gleam's JavaScript build layout where modules live
/// under `build/dev/javascript/<package>/<module>.mjs`.
///
/// ## Examples
///
/// ```gleam
/// // For `my_app/worker.gleam` in package `my_app`:
/// let assert Ok(w) =
///   worker.from_module("my_app/worker")
///   |> worker.with_on_message(handle_message)
///   |> worker.build
/// ```
///
@external(javascript, "./worker.ffi.mjs", "from_module")
pub fn from_module(name: String) -> Builder

/// Sets the worker name, used by debugging tools to identify the
/// thread. Empty by default.
///
pub fn with_name(builder: Builder, name: String) -> Builder {
  Builder(..builder, name:)
}

/// Registers a handler invoked for each message the worker sends back.
/// The handler receives the [`Worker`](#Worker) so it can reply via
/// [`post_message`](#post_message). `ArrayBuffer` payloads are exposed
/// as `BitArray`; other values pass through unchanged. Decode the
/// payload with `gleam/dynamic/decode`.
///
pub fn with_on_message(
  builder: Builder,
  run handler: fn(Worker, Dynamic) -> a,
) -> Builder {
  Builder(
    ..builder,
    on_message: Some(fn(worker, data) {
      handler(worker, data)
      Nil
    }),
  )
}

/// Spawns the worker from the configured `Builder`. Returns an error
/// if the runtime rejects the URL or the worker constructor fails
/// synchronously. Asynchronous loading failures (missing script,
/// syntax error in the script, etc.) are not surfaced — write worker
/// scripts in Gleam to keep them within the language's Result-driven
/// error model.
///
pub fn build(builder: Builder) -> Result(Worker, Nil) {
  do_build(builder.url, builder.name, builder.on_message)
}

@external(javascript, "./worker.ffi.mjs", "build")
@internal
pub fn do_build(
  url: String,
  name: String,
  on_message: Option(fn(Worker, Dynamic) -> Nil),
) -> Result(Worker, Nil)

/// Sends `data` to the worker. Returns an error if `data` can't be
/// serialized by the structured-clone algorithm — functions, symbols,
/// and most class instances are not cloneable.
///
@external(javascript, "./worker.ffi.mjs", "post_message")
pub fn post_message(to worker: Worker, data data: a) -> Result(Nil, Nil)

/// Stops the worker thread immediately. Any queued messages are
/// discarded and the worker's script is not given a chance to clean
/// up.
///
@external(javascript, "./worker.ffi.mjs", "terminate")
pub fn terminate(worker: Worker) -> Nil
