//// The transform side of the Streams API — a writable + readable pair
//// where each chunk written passes through a transformer to produce
//// output. Pipe one through `readable_stream.pipe_through` to
//// connect transformations.

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option, None, Some}
import gossamer/stream.{type QueuingStrategy, type StreamLifecycleError}
import gossamer/stream/readable_stream.{type ReadableStream}
import gossamer/stream/transform_stream/default_controller.{
  type DefaultController,
}
import gossamer/stream/writable_stream.{type WritableStream}

/// A JavaScript `TransformStream` — a writable side that receives
/// input and a readable side that produces transformed output.
///
/// See [TransformStream](https://developer.mozilla.org/en-US/docs/Web/API/TransformStream) on MDN.
///
@external(javascript, "./transform_stream.type.ts", "TransformStream$")
pub type TransformStream(input, output)

/// The configuration for a `TransformStream`. Construct with `new` and
/// refine with `with_start`, `with_transform`, `with_flush`, `with_cancel`,
/// `with_writable_strategy`, and `with_readable_strategy`, then call
/// `build` to create the stream.
///
pub opaque type Builder(input, output) {
  Builder(
    start: Option(fn(DefaultController(output)) -> Nil),
    transform: Option(fn(input, DefaultController(output)) -> Promise(Nil)),
    flush: Option(fn(DefaultController(output)) -> Promise(Nil)),
    cancel: Option(fn(Dynamic) -> Promise(Nil)),
    writable_strategy: Option(QueuingStrategy),
    readable_strategy: Option(QueuingStrategy),
  )
}

/// Creates a `Builder` with no transformer callbacks set.
///
pub fn new() -> Builder(input, output) {
  Builder(
    start: None,
    transform: None,
    flush: None,
    cancel: None,
    writable_strategy: None,
    readable_strategy: None,
  )
}

/// Registers the `start` callback that runs once at construction. Use to
/// enqueue initial chunks or set up state.
///
pub fn with_start(
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
pub fn with_transform(
  builder: Builder(input, output),
  run callback: fn(input, DefaultController(output)) -> Promise(Nil),
) -> Builder(input, output) {
  Builder(..builder, transform: Some(callback))
}

/// Registers the `flush` callback that runs once after the writable side
/// closes. Use to emit any buffered output.
///
pub fn with_flush(
  builder: Builder(input, output),
  run callback: fn(DefaultController(output)) -> Promise(Nil),
) -> Builder(input, output) {
  Builder(..builder, flush: Some(callback))
}

/// Registers the `cancel` callback that runs when either side is aborted.
/// Receives the cancellation reason.
///
pub fn with_cancel(
  builder: Builder(input, output),
  run callback: fn(Dynamic) -> Promise(Nil),
) -> Builder(input, output) {
  Builder(..builder, cancel: Some(callback))
}

/// Sets the queuing strategy for the writable side of the transform.
/// Without this, the writable side uses the default strategy
/// (chunk count, high water mark of `1`).
///
pub fn with_writable_strategy(
  builder: Builder(input, output),
  strategy: QueuingStrategy,
) -> Builder(input, output) {
  Builder(..builder, writable_strategy: Some(strategy))
}

/// Sets the queuing strategy for the readable side of the transform.
/// Without this, the readable side uses the default strategy
/// (chunk count, high water mark of `0` — which buffers nothing
/// downstream until the consumer pulls).
///
pub fn with_readable_strategy(
  builder: Builder(input, output),
  strategy: QueuingStrategy,
) -> Builder(input, output) {
  Builder(..builder, readable_strategy: Some(strategy))
}

/// Creates a `TransformStream` from the configured `Builder`. Returns
/// `Errored` if the `start` callback throws synchronously; the thrown
/// value is the variant's reason.
///
pub fn build(
  builder: Builder(input, output),
) -> Result(TransformStream(input, output), StreamLifecycleError) {
  do_build(
    builder.start,
    builder.transform,
    builder.flush,
    builder.cancel,
    builder.writable_strategy,
    builder.readable_strategy,
  )
}

@external(javascript, "./transform_stream.ffi.mjs", "build")
@internal
pub fn do_build(
  start: Option(fn(DefaultController(output)) -> Nil),
  transform: Option(fn(input, DefaultController(output)) -> Promise(Nil)),
  flush: Option(fn(DefaultController(output)) -> Promise(Nil)),
  cancel: Option(fn(Dynamic) -> Promise(Nil)),
  writable_strategy: Option(QueuingStrategy),
  readable_strategy: Option(QueuingStrategy),
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
