import gleeunit/should
import gossamer/weak_ref

pub fn deref_object_test() {
  let target = #("opaque-tuple-target")
  let assert Ok(ref) = weak_ref.new(target)
  weak_ref.deref(ref) |> should.equal(Ok(target))
}

pub fn deref_after_repeated_calls_test() {
  let target = #(1, 2, 3)
  let assert Ok(ref) = weak_ref.new(target)
  weak_ref.deref(ref) |> should.equal(Ok(target))
  weak_ref.deref(ref) |> should.equal(Ok(target))
}

pub fn new_primitive_target_errors_test() {
  let assert Error(_) = weak_ref.new(42)
}

pub fn new_string_target_errors_test() {
  let assert Error(_) = weak_ref.new("primitive-string")
}
