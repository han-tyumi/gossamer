import gleam/option.{type Option}

pub type ReadResult(a) {
  Value(a)
  Done(Option(a))
}
