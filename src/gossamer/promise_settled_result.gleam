import gleam/dynamic.{type Dynamic}

pub type PromiseSettledResult(a) {
  Fulfilled(value: a)
  Rejected(reason: Dynamic)
}
