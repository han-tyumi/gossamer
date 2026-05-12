import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option, None, Some}
import gossamer/stream.{type StreamLifecycleError}
import gossamer/stream/readable_stream.{type ReadableStream}
import gossamer/stream/transform_stream/default_controller.{
  type DefaultController,
}
import gossamer/stream/writable_stream.{type WritableStream}

/// A pair of streams — a writable side that receives input and a readable
/// side that produces transformed output.
///
/// See [TransformStream](https://developer.mozilla.org/en-US/docs/Web/API/TransformStream) on MDN.
///
@external(javascript, "./transform_stream.type.ts", "TransformStream$")
pub type TransformStream(input, output)

/// The configuration for a `TransformStream`. Construct with `new` and
/// refine with `on_start`, `on_transform`, `on_flush`, and `on_cancel`,
/// then call `build` to create the stream.
///
pub type Builder(input, output) {
  Builder(
    start: Option(fn(DefaultController(output)) -> Nil),
    transform: Option(fn(input, DefaultController(output)) -> Promise(Nil)),
    flush: Option(fn(DefaultController(output)) -> Promise(Nil)),
    cancel: Option(fn(Dynamic) -> Promise(Nil)),
  )
}

/// Creates a `Builder` with no transformer callbacks set.
///
pub fn new() -> Builder(input, output) {
  Builder(start: None, transform: None, flush: None, cancel: None)
}

/// Registers the `start` callback that runs once at construction. Use to
/// enqueue initial chunks or set up state.
///
pub fn on_start(
  builder: Builder(input, output),
  run callback: fn(DefaultController(output)) -> a,
) -> Builder(input, output) {
  Builder(
    ..builder,
    start: Some(fn(controller) {
      callback(controller)
      Nil
    }),
  )
}

/// Registers the `transform` callback that runs for each input chunk. Use
/// to map input chunks to output chunks.
///
pub fn on_transform(
  builder: Builder(input, output),
  run callback: fn(input, DefaultController(output)) -> Promise(Nil),
) -> Builder(input, output) {
  Builder(..builder, transform: Some(callback))
}

/// Registers the `flush` callback that runs once after the writable side
/// closes. Use to emit any buffered output.
///
pub fn on_flush(
  builder: Builder(input, output),
  run callback: fn(DefaultController(output)) -> Promise(Nil),
) -> Builder(input, output) {
  Builder(..builder, flush: Some(callback))
}

/// Registers the `cancel` callback that runs when either side is aborted.
/// Receives the cancellation reason.
///
pub fn on_cancel(
  builder: Builder(input, output),
  run callback: fn(Dynamic) -> Promise(Nil),
) -> Builder(input, output) {
  Builder(..builder, cancel: Some(callback))
}

/// Creates a `TransformStream` from the configured `Builder`. Returns
/// `Errored` if the `start` callback throws synchronously; the thrown
/// value is the variant's reason.
///
@external(javascript, "./transform_stream.ffi.mjs", "build")
pub fn build(
  builder: Builder(input, output),
) -> Result(TransformStream(input, output), StreamLifecycleError)

/// Creates a `TransformStream` from only a `transform` callback — use
/// when the transformer just maps input chunks to output chunks.
///
@external(javascript, "./transform_stream.ffi.mjs", "from_transform")
pub fn from_transform(
  transform: fn(input, DefaultController(output)) -> Promise(Nil),
) -> TransformStream(input, output)

/// The readable side of the stream, producing the transformed output
/// chunks.
///
@external(javascript, "./transform_stream.ffi.mjs", "readable")
pub fn readable(
  stream: TransformStream(input, output),
) -> ReadableStream(output)

/// The writable side of the stream, accepting the input chunks.
///
@external(javascript, "./transform_stream.ffi.mjs", "writable")
pub fn writable(stream: TransformStream(input, output)) -> WritableStream(input)
