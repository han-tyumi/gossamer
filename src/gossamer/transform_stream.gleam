import gleam/dynamic.{type Dynamic}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/transform_stream/default_controller.{type DefaultController}
import gossamer/writable_stream.{type WritableStream}

/// A pair of streams — a writable side that receives input and a readable
/// side that produces transformed output.
///
/// See [TransformStream](https://developer.mozilla.org/en-US/docs/Web/API/TransformStream) on MDN.
///
@external(javascript, "./transform_stream.type.ts", "TransformStream$")
pub type TransformStream(input, output)

pub type Transformer(input, output) {
  Start(fn(DefaultController(output)) -> Nil)
  Transform(fn(input, DefaultController(output)) -> Promise(Nil))
  Flush(fn(DefaultController(output)) -> Promise(Nil))
  Cancel(fn(Dynamic) -> Promise(Nil))
}

/// Creates a `TransformStream` driven by the given transformer callbacks
/// (`Start`, `Transform`, `Flush`, `Cancel`).
///
@external(javascript, "./transform_stream.ffi.mjs", "new_")
pub fn new(
  transformer: List(Transformer(input, output)),
) -> TransformStream(input, output)

/// Creates a `TransformStream` from only a `Transform` callback — use when
/// the transformer just maps input chunks to output chunks.
///
pub fn from_transform(
  transform: fn(input, DefaultController(output)) -> Promise(Nil),
) -> TransformStream(input, output) {
  new([Transform(transform)])
}

@external(javascript, "./transform_stream.ffi.mjs", "readable")
pub fn readable(
  of stream: TransformStream(input, output),
) -> ReadableStream(output)

@external(javascript, "./transform_stream.ffi.mjs", "writable")
pub fn writable(
  of stream: TransformStream(input, output),
) -> WritableStream(input)
