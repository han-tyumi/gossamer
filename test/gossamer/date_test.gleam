import gleeunit/should
import gossamer/date

pub fn new_test() {
  let now = date.now()
  let d = date.new()
  let time = date.time(d)

  // The new date's timestamp should be very close to Date.now()
  let diff = time - now
  should.be_true(diff >= 0 && diff < 1000)
}

pub fn from_time_test() {
  // 2026-01-15T12:00:00.000Z
  let timestamp = 1_768_478_400_000
  let d = date.from_time(timestamp)
  date.time(d) |> should.equal(timestamp)
}

pub fn from_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  date.utc_full_year(d) |> should.equal(2026)
  date.utc_month(d) |> should.equal(3)
  date.utc_date(d) |> should.equal(9)
  date.utc_hours(d) |> should.equal(14)
  date.utc_minutes(d) |> should.equal(30)
}

pub fn from_string_invalid_test() {
  date.from_string("not a date") |> should.equal(Error(Nil))
}

pub fn now_test() {
  let timestamp = date.now()
  should.be_true(timestamp > 0)
}

pub fn parse_test() {
  let assert Ok(timestamp) = date.parse("2026-04-09T00:00:00.000Z")
  should.be_true(timestamp > 0)
}

pub fn parse_invalid_test() {
  date.parse("not a date") |> should.equal(Error(Nil))
}

pub fn time_test() {
  let timestamp = 1_768_478_400_000
  let d = date.from_time(timestamp)
  date.time(d) |> should.equal(timestamp)
}

pub fn full_year_test() {
  let d = date.new()
  date.set_full_year(d, 2026)
  date.full_year(d) |> should.equal(2026)
}

pub fn month_test() {
  let d = date.new()
  date.set_date(d, 1)
  date.set_month(d, 5)
  date.month(d) |> should.equal(5)
}

pub fn date_test() {
  let d = date.new()
  date.set_date(d, 15)
  date.date(d) |> should.equal(15)
}

pub fn day_test() {
  // Day is read-only; verify it returns 0–6
  let d = date.new()
  let day_of_week = date.day(d)
  should.be_true(day_of_week >= 0 && day_of_week <= 6)
}

pub fn hours_test() {
  let d = date.new()
  date.set_hours(d, 14)
  date.hours(d) |> should.equal(14)
}

pub fn minutes_test() {
  let d = date.new()
  date.set_minutes(d, 30)
  date.minutes(d) |> should.equal(30)
}

pub fn seconds_test() {
  let d = date.new()
  date.set_seconds(d, 45)
  date.seconds(d) |> should.equal(45)
}

pub fn milliseconds_test() {
  let d = date.new()
  date.set_milliseconds(d, 123)
  date.milliseconds(d) |> should.equal(123)
}

pub fn utc_full_year_test() {
  let assert Ok(d) = date.from_string("2026-12-31T23:59:59.000Z")
  date.utc_full_year(d) |> should.equal(2026)
}

pub fn utc_month_test() {
  let assert Ok(d) = date.from_string("2026-12-31T23:59:59.000Z")
  date.utc_month(d) |> should.equal(11)
}

pub fn utc_date_test() {
  let assert Ok(d) = date.from_string("2026-12-31T23:59:59.000Z")
  date.utc_date(d) |> should.equal(31)
}

pub fn utc_day_test() {
  // 2026-12-31 is a Thursday (day 4)
  let assert Ok(d) = date.from_string("2026-12-31T12:00:00.000Z")
  date.utc_day(d) |> should.equal(4)
}

pub fn utc_hours_test() {
  let assert Ok(d) = date.from_string("2026-04-09T23:00:00.000Z")
  date.utc_hours(d) |> should.equal(23)
}

pub fn utc_minutes_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:59:00.000Z")
  date.utc_minutes(d) |> should.equal(59)
}

pub fn utc_seconds_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:59.000Z")
  date.utc_seconds(d) |> should.equal(59)
}

pub fn utc_milliseconds_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.999Z")
  date.utc_milliseconds(d) |> should.equal(999)
}

pub fn timezone_offset_test() {
  let d = date.new()

  // Timezone offset is an integer (minutes from UTC)
  let offset = date.timezone_offset(d)
  should.be_true(offset >= -720 && offset <= 840)
}

pub fn set_time_test() {
  let d = date.new()
  let timestamp = 1_768_478_400_000
  date.set_time(d, timestamp)
  date.time(d) |> should.equal(timestamp)
}

pub fn set_full_year_test() {
  let d = date.new()
  date.set_full_year(d, 2030)
  date.full_year(d) |> should.equal(2030)
}

pub fn set_month_test() {
  let d = date.new()
  date.set_date(d, 1)
  date.set_month(d, 11)
  date.month(d) |> should.equal(11)
}

pub fn set_date_test() {
  let d = date.new()
  date.set_date(d, 28)
  date.date(d) |> should.equal(28)
}

pub fn set_hours_test() {
  let d = date.new()
  date.set_hours(d, 18)
  date.hours(d) |> should.equal(18)
}

pub fn set_minutes_test() {
  let d = date.new()
  date.set_minutes(d, 45)
  date.minutes(d) |> should.equal(45)
}

pub fn set_seconds_test() {
  let d = date.new()
  date.set_seconds(d, 30)
  date.seconds(d) |> should.equal(30)
}

pub fn set_milliseconds_test() {
  let d = date.new()
  date.set_milliseconds(d, 500)
  date.milliseconds(d) |> should.equal(500)
}

pub fn set_utc_full_year_test() {
  let assert Ok(d) = date.from_string("2026-06-15T12:00:00.000Z")
  date.set_utc_full_year(d, 2000)
  date.utc_full_year(d) |> should.equal(2000)
}

pub fn set_utc_month_test() {
  let assert Ok(d) = date.from_string("2026-06-15T12:00:00.000Z")
  date.set_utc_month(d, 11)
  date.utc_month(d) |> should.equal(11)
}

pub fn set_utc_date_test() {
  let assert Ok(d) = date.from_string("2026-06-15T12:00:00.000Z")
  date.set_utc_date(d, 28)
  date.utc_date(d) |> should.equal(28)
}

pub fn set_utc_hours_test() {
  let assert Ok(d) = date.from_string("2026-06-15T12:00:00.000Z")
  date.set_utc_hours(d, 18)
  date.utc_hours(d) |> should.equal(18)
}

pub fn set_utc_minutes_test() {
  let assert Ok(d) = date.from_string("2026-06-15T12:00:00.000Z")
  date.set_utc_minutes(d, 15)
  date.utc_minutes(d) |> should.equal(15)
}

pub fn set_utc_seconds_test() {
  let assert Ok(d) = date.from_string("2026-06-15T12:00:00.000Z")
  date.set_utc_seconds(d, 42)
  date.utc_seconds(d) |> should.equal(42)
}

pub fn set_utc_milliseconds_test() {
  let assert Ok(d) = date.from_string("2026-06-15T12:00:00.000Z")
  date.set_utc_milliseconds(d, 750)
  date.utc_milliseconds(d) |> should.equal(750)
}

pub fn to_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  let string = date.to_string(d)

  // toString returns a non-empty runtime-dependent string
  should.be_true(string != "")
}

pub fn to_date_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  let string = date.to_date_string(d)
  should.be_true(string != "")
}

pub fn to_time_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  let string = date.to_time_string(d)
  should.be_true(string != "")
}

pub fn to_iso_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  date.to_iso_string(d) |> should.equal("2026-04-09T14:30:00.000Z")
}

pub fn to_utc_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  date.to_utc_string(d) |> should.equal("Thu, 09 Apr 2026 14:30:00 GMT")
}

pub fn to_json_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  date.to_json(d) |> should.equal("2026-04-09T14:30:00.000Z")
}

pub fn to_locale_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  let string = date.to_locale_string(d)
  should.be_true(string != "")
}

pub fn to_locale_date_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  let string = date.to_locale_date_string(d)
  should.be_true(string != "")
}

pub fn to_locale_time_string_test() {
  let assert Ok(d) = date.from_string("2026-04-09T14:30:00.000Z")
  let string = date.to_locale_time_string(d)
  should.be_true(string != "")
}

pub fn setter_returns_date_test() {
  let assert Ok(d) = date.from_string("2026-01-01T00:00:00.000Z")

  // Setters return the date, enabling pipeline usage
  date.set_utc_full_year(d, 2030)
  |> date.set_utc_month(to: 5)
  |> date.set_utc_date(to: 15)

  date.utc_full_year(d) |> should.equal(2030)
  date.utc_month(d) |> should.equal(5)
  date.utc_date(d) |> should.equal(15)
}

pub fn epoch_test() {
  let d = date.from_time(0)
  date.utc_full_year(d) |> should.equal(1970)
  date.utc_month(d) |> should.equal(0)
  date.utc_date(d) |> should.equal(1)
  date.utc_hours(d) |> should.equal(0)
  date.utc_minutes(d) |> should.equal(0)
  date.utc_seconds(d) |> should.equal(0)
  date.utc_milliseconds(d) |> should.equal(0)
}
