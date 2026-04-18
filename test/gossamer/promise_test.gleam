import gleam/dynamic/decode
import gleam/option.{None, Some}
import gleeunit/should
import gossamer
import gossamer/promise

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
  should.equal(value, Ok(5))
}

pub fn new_promise_reject_test() {
  let promise =
    promise.new(fn(_resolve, reject) {
      reject("error")
      Nil
    })
  use result <- promise.then(promise)
  should.be_error(result)
  promise.resolve(Nil)
}

pub fn promise_all_test() {
  let promise =
    [promise.resolve(1), promise.resolve(2), promise.resolve(3)]
    |> promise.all
  use values <- promise.then(promise)
  should.equal(values, Ok([1, 2, 3]))
}

pub fn promise_race_test() {
  let promise1 =
    promise.new(fn(resolve, _reject) {
      gossamer.set_timeout(100, fn() { resolve("first") })
      Nil
    })
  let promise2 = promise.resolve(Ok("second"))
  let race_promise = promise.race([promise1, promise2])
  use value <- promise.then(race_promise)
  should.equal(value, Ok(Ok("second")))
}

pub fn promise_any_test() {
  let promise1 = promise.reject("error1")
  let promise2 = promise.reject("error2")
  let promise3 = promise.resolve("success")
  let any_promise = promise.any([promise1, promise2, promise3])
  use value <- promise.then(any_promise)
  should.equal(value, Ok("success"))
}

pub fn promise_all_settled_test() {
  let promise1 = promise.resolve(1)
  let promise2 = promise.reject("error")
  let all_settled_promise = promise.all_settled([promise1, promise2])
  use results <- promise.then(all_settled_promise)
  case results {
    [promise.Fulfilled(1), promise.Rejected(_)] -> Nil
    _ -> should.fail()
  }
}

pub fn try_success_test() {
  let result_promise = promise.try(fn() { 42 })
  use result <- promise.then(result_promise)
  should.equal(result, Ok(42))
  promise.resolve(Nil)
}

pub fn try_sync_value_test() {
  let result_promise = promise.try(fn() { "hello" })
  use result <- promise.then(result_promise)
  should.equal(result, Ok("hello"))
  promise.resolve(Nil)
}

pub fn try_throwing_test() {
  let result_promise =
    promise.try(fn() {
      let assert Ok(decoded) = gossamer.atob("!!!invalid!!!")
      decoded
    })
  use result <- promise.then(result_promise)
  should.be_error(result)
  promise.resolve(Nil)
}

pub fn finally_test() {
  let resolvers = promise.with_resolvers()
  let finally_ran = promise.with_resolvers()

  promise.finally(resolvers.promise, fn() {
    finally_ran.resolve(True)
    Nil
  })

  resolvers.resolve(42)

  use ran <- promise.then(finally_ran.promise)
  should.equal(ran, Ok(True))
  promise.resolve(Nil)
}

pub fn from_result_ok_test() {
  let p = promise.from_result(Ok(42))
  use value <- promise.then(p)
  should.equal(value, 42)
  promise.resolve(Nil)
}

pub fn from_result_error_test() {
  let p: promise.Promise(String) = promise.from_result(Error("bad"))
  let recovered =
    promise.catch(p, fn(reason) {
      let assert Ok(msg) = decode.run(reason, decode.string)
      should.equal(msg, "bad")
      "recovered"
    })
  use value <- promise.then(recovered)
  should.equal(value, "recovered")
  promise.resolve(Nil)
}

pub fn from_option_some_test() {
  let p = promise.from_option(Some(99))
  use value <- promise.then(p)
  should.equal(value, 99)
  promise.resolve(Nil)
}

pub fn from_option_none_test() {
  let p: promise.Promise(String) = promise.from_option(None)
  let recovered = promise.catch(p, fn(_reason) { "caught" })
  use value <- promise.then(recovered)
  should.equal(value, "caught")
  promise.resolve(Nil)
}
