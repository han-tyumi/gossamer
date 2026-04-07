import gossamer/promise.{type Promise}
import gossamer/transform_stream/default_controller.{type DefaultController}
import gleam/dynamic.{type Dynamic}

pub type Transformer(input, output) {
  Start(fn(DefaultController(output)) -> Nil)
  Transform(fn(input, DefaultController(output)) -> Promise(Nil))
  Flush(fn(DefaultController(output)) -> Promise(Nil))
  Cancel(fn(Dynamic) -> Promise(Nil))
}
