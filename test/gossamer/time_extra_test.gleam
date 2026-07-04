import gleam/time/calendar
import gleam/time/timestamp
import gleeunit/should
import gossamer/time_extra

pub fn to_utc_string_test() {
  timestamp.unix_epoch
  |> time_extra.to_utc_string
  |> should.equal("Thu, 01 Jan 1970 00:00:00 GMT")
}

pub fn day_of_week_test() {
  timestamp.unix_epoch
  |> time_extra.day_of_week(calendar.utc_offset)
  |> should.equal(time_extra.Thursday)
}

pub fn weekday_to_string_test() {
  time_extra.weekday_to_string(time_extra.Monday) |> should.equal("Monday")
  time_extra.weekday_to_string(time_extra.Sunday) |> should.equal("Sunday")
}

pub fn weekday_to_int_test() {
  time_extra.weekday_to_int(time_extra.Monday) |> should.equal(1)
  time_extra.weekday_to_int(time_extra.Sunday) |> should.equal(7)
}

pub fn weekday_from_int_test() {
  time_extra.weekday_from_int(1) |> should.equal(Ok(time_extra.Monday))
  time_extra.weekday_from_int(7) |> should.equal(Ok(time_extra.Sunday))
}

pub fn weekday_from_int_out_of_range_test() {
  time_extra.weekday_from_int(0) |> should.be_error()
  time_extra.weekday_from_int(8) |> should.be_error()
}

pub fn to_utc_string_beyond_js_date_range_test() {
  // Beyond the range JavaScript dates support (|ms| > 8.64e15); the
  // arithmetic implementation covers the full Timestamp range.
  timestamp.from_unix_seconds(9_000_000_000_000_000)
  |> time_extra.to_utc_string
  |> should.equal("Wed, 24 Jul 285200616 16:00:00 GMT")
}

pub fn day_of_week_beyond_js_date_range_test() {
  timestamp.from_unix_seconds(9_000_000_000_000_000)
  |> time_extra.day_of_week(calendar.utc_offset)
  |> should.equal(time_extra.Wednesday)
}
