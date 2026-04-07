import gossamer/promise.{type Promise}
import gossamer/writable_stream/default_controller.{type DefaultController}
import gleam/dynamic.{type Dynamic}

pub type UnderlyingSink(a) {
  Start(fn(DefaultController) -> Nil)
  Write(fn(a, DefaultController) -> Promise(Nil))
  Close(fn() -> Promise(Nil))
  Abort(fn(Dynamic) -> Promise(Nil))
}
