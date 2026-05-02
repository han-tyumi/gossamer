import gleeunit/should
import gossamer/weak_map

pub fn new_test() {
  let _ = weak_map.new()
}

pub fn set_object_key_test() {
  let key = #("opaque-tuple-key")
  let assert Ok(map) = weak_map.set(weak_map.new(), key, 42)
  weak_map.has(map, key) |> should.be_true
  weak_map.get(map, key) |> should.equal(Ok(42))
}

pub fn set_overwrite_test() {
  let key = #(1, 2)
  let assert Ok(map) = weak_map.set(weak_map.new(), key, "first")
  let assert Ok(map) = weak_map.set(map, key, "second")
  weak_map.get(map, key) |> should.equal(Ok("second"))
}

pub fn delete_test() {
  let key = #("k")
  let assert Ok(map) = weak_map.set(weak_map.new(), key, 1)
  weak_map.delete(map, key)
  weak_map.has(map, key) |> should.be_false
  weak_map.get(map, key) |> should.be_error
}

pub fn delete_missing_test() {
  let key = #("missing")
  let map = weak_map.new()
  weak_map.delete(map, key)
  weak_map.has(map, key) |> should.be_false
}

pub fn has_missing_test() {
  let key = #("missing")
  weak_map.has(weak_map.new(), key) |> should.be_false
}

pub fn get_missing_test() {
  let key = #("missing")
  weak_map.get(weak_map.new(), key) |> should.be_error
}

pub fn from_list_test() {
  let key1 = #("a")
  let key2 = #("b")
  let assert Ok(map) = weak_map.from_list([#(key1, 1), #(key2, 2)])
  weak_map.get(map, key1) |> should.equal(Ok(1))
  weak_map.get(map, key2) |> should.equal(Ok(2))
}

pub fn set_primitive_key_errors_test() {
  let assert Error(_) = weak_map.set(weak_map.new(), 42, "value")
}

pub fn from_list_primitive_key_errors_test() {
  let assert Error(_) = weak_map.from_list([#("primitive-string-key", 1)])
}
