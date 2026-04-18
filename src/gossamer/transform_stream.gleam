import gleam/dynamic.{type Dynamic}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/transform_stream/default_controller.{type DefaultController}
import gossamer/writable_stream.{type WritableStream}

@external(javascript, "./transform_stream.type.ts", "TransformStream$")
pub type TransformStream(input, output)

pub type Transformer(input, output) {
  Start(fn(DefaultController(output)) -> Nil)
  Transform(fn(input, DefaultController(output)) -> Promise(Nil))
  Flush(fn(DefaultController(output)) -> Promise(Nil))
  Cancel(fn(Dynamic) -> Promise(Nil))
}

@external(javascript, "./transform_stream.ffi.mjs", "new_")
pub fn new(
  transformer: List(Transformer(input, output)),
) -> TransformStream(input, output)

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
