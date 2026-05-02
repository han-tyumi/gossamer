import gleeunit/should
import gossamer/weak_set

pub fn new_test() {
  let _ = weak_set.new()
}

pub fn add_object_test() {
  let value = #("opaque-tuple-value")
  let assert Ok(set) = weak_set.add(weak_set.new(), value)
  weak_set.has(set, value) |> should.be_true
}

pub fn add_idempotent_test() {
  let value = #(1, 2)
  let assert Ok(set) = weak_set.add(weak_set.new(), value)
  let assert Ok(set) = weak_set.add(set, value)
  weak_set.has(set, value) |> should.be_true
}

pub fn delete_test() {
  let value = #("v")
  let assert Ok(set) = weak_set.add(weak_set.new(), value)
  weak_set.delete(set, value)
  weak_set.has(set, value) |> should.be_false
}

pub fn delete_missing_test() {
  let value = #("missing")
  let set = weak_set.new()
  weak_set.delete(set, value)
  weak_set.has(set, value) |> should.be_false
}

pub fn has_missing_test() {
  let value = #("missing")
  weak_set.has(weak_set.new(), value) |> should.be_false
}

pub fn from_list_test() {
  let value1 = #("a")
  let value2 = #("b")
  let assert Ok(set) = weak_set.from_list([value1, value2])
  weak_set.has(set, value1) |> should.be_true
  weak_set.has(set, value2) |> should.be_true
}

pub fn add_primitive_errors_test() {
  let assert Error(_) = weak_set.add(weak_set.new(), 42)
}

pub fn from_list_primitive_errors_test() {
  let assert Error(_) = weak_set.from_list(["primitive-string"])
}
