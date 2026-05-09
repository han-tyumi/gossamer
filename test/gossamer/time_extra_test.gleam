import gleam/string
import gleam/time/calendar
import gleam/time/timestamp
import gleeunit/should
import gossamer/time_extra

pub fn to_locale_string_test() {
  timestamp.unix_epoch
  |> time_extra.to_locale_string
  |> string.is_empty
  |> should.be_false
}

pub fn to_locale_date_string_test() {
  timestamp.unix_epoch
  |> time_extra.to_locale_date_string
  |> string.is_empty
  |> should.be_false
}

pub fn to_locale_time_string_test() {
  timestamp.unix_epoch
  |> time_extra.to_locale_time_string
  |> string.is_empty
  |> should.be_false
}

pub fn to_utc_string_test() {
  timestamp.unix_epoch
  |> time_extra.to_utc_string
  |> should.equal("Thu, 01 Jan 1970 00:00:00 GMT")
}

pub fn day_of_week_test() {
  timestamp.unix_epoch
  |> time_extra.day_of_week(calendar.utc_offset)
  |> should.equal(4)
}
