import gleam/dict
import gleeunit/should
import gossamer/json

pub fn parse_null_test() {
  json.parse("null") |> should.equal(Ok(json.Null))
}

pub fn parse_boolean_test() {
  json.parse("true") |> should.equal(Ok(json.Boolean(True)))
  json.parse("false") |> should.equal(Ok(json.Boolean(False)))
}

pub fn parse_number_test() {
  json.parse("42.5") |> should.equal(Ok(json.Number(42.5)))
}

pub fn parse_integer_test() {
  json.parse("42") |> should.equal(Ok(json.Number(42.0)))
}

pub fn parse_string_test() {
  json.parse("\"hello\"") |> should.equal(Ok(json.String("hello")))
}

pub fn parse_array_test() {
  json.parse("[1, 2, 3]")
  |> should.equal(
    Ok(json.Array([json.Number(1.0), json.Number(2.0), json.Number(3.0)])),
  )
}

pub fn parse_object_test() {
  let assert Ok(result) = json.parse("{\"key\": \"value\"}")
  should.equal(
    result,
    json.Object(dict.from_list([#("key", json.String("value"))])),
  )
}

pub fn parse_invalid_test() {
  json.parse("not json") |> should.be_error
}

pub fn stringify_null_test() {
  json.stringify(json.Null) |> should.equal("null")
}

pub fn stringify_boolean_test() {
  json.stringify(json.Boolean(True)) |> should.equal("true")
  json.stringify(json.Boolean(False)) |> should.equal("false")
}

pub fn stringify_number_test() {
  json.stringify(json.Number(42.5)) |> should.equal("42.5")
}

pub fn stringify_string_test() {
  json.stringify(json.String("hello")) |> should.equal("\"hello\"")
}

pub fn stringify_array_test() {
  json.stringify(json.Array([json.Number(1.0), json.Number(2.0)]))
  |> should.equal("[1,2]")
}

pub fn stringify_object_test() {
  json.stringify(json.Object(dict.from_list([#("key", json.String("value"))])))
  |> should.equal("{\"key\":\"value\"}")
}

pub fn roundtrip_test() {
  let value =
    json.Object(
      dict.from_list([
        #("name", json.String("test")),
        #("count", json.Number(5.0)),
        #("active", json.Boolean(True)),
        #("tags", json.Array([json.String("a"), json.String("b")])),
        #("meta", json.Null),
      ]),
    )
  let assert Ok(parsed) = json.stringify(value) |> json.parse
  should.equal(parsed, value)
}
