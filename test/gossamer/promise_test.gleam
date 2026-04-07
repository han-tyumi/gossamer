import gossamer
import gossamer/promise
import gossamer/promise_settled_result
import gleam/dynamic/decode
import gleeunit/should

pub fn resolve_promise_test() {
  let promise = promise.resolve(42)
  use value <- promise.then(promise)
  should.equal(value, 42)
}

pub fn reject_promise_test() {
  let promise = promise.reject("error")
  use reason <- promise.catch(promise)
  let assert Ok(reason) = decode.run(reason, decode.string)
  should.equal(reason, "error")
}

pub fn new_promise_resolve_test() {
  let promise =
    promise.new(fn(resolve, _reject) {
      resolve(5)
      Nil
    })
  use value <- promise.then(promise)
  should.equal(value, 5)
}

pub fn new_promise_reject_test() {
  let promise =
    promise.new(fn(_resolve, reject) {
      reject("error")
      Nil
    })
  use reason <- promise.catch(promise)
  let assert Ok(reason) = decode.run(reason, decode.string)
  should.equal(reason, "error")
}

pub fn promise_all_test() {
  let promise =
    [promise.resolve(1), promise.resolve(2), promise.resolve(3)]
    |> promise.all
  use values <- promise.then(promise)
  should.equal(values, [1, 2, 3])
}

pub fn promise_race_test() {
  let promise1 =
    promise.new(fn(resolve, _reject) {
      gossamer.set_timeout(100, fn() { resolve("first") })
      Nil
    })
  let promise2 = promise.resolve("second")
  let race_promise = promise.race([promise1, promise2])
  use value <- promise.then(race_promise)
  should.equal(value, "second")
}

pub fn promise_any_test() {
  let promise1 = promise.reject("error1")
  let promise2 = promise.reject("error2")
  let promise3 = promise.resolve("success")
  let any_promise = promise.any([promise1, promise2, promise3])
  use value <- promise.then(any_promise)
  should.equal(value, "success")
}

pub fn promise_all_settled_test() {
  let promise1 = promise.resolve(1)
  let promise2 = promise.reject("error")
  let all_settled_promise = promise.all_settled([promise1, promise2])
  use results <- promise.then(all_settled_promise)
  case results {
    [promise_settled_result.Fulfilled(1), promise_settled_result.Rejected(_)] ->
      Nil
    _ -> should.fail()
  }
}

