//// Extras for `gleam/time/timestamp` — RFC 7231 HTTP date-header
//// strings and day-of-week, neither of which `gleam_time` exposes
//// itself.

import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}

/// A day of the week. Mirrors the shape of
/// [`gleam/time/calendar.Month`](https://hexdocs.pm/gleam_time/gleam/time/calendar.html#Month).
///
pub type Weekday {
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
  Sunday
}

/// Returns the English name for the weekday.
///
/// ## Examples
///
/// ```gleam
/// weekday_to_string(Monday)
/// // -> "Monday"
/// ```
///
pub fn weekday_to_string(weekday: Weekday) -> String {
  case weekday {
    Monday -> "Monday"
    Tuesday -> "Tuesday"
    Wednesday -> "Wednesday"
    Thursday -> "Thursday"
    Friday -> "Friday"
    Saturday -> "Saturday"
    Sunday -> "Sunday"
  }
}

/// Returns the number for the weekday, where Monday is 1 and Sunday is 7,
/// following ISO 8601.
///
/// ## Examples
///
/// ```gleam
/// weekday_to_int(Monday)
/// // -> 1
/// ```
///
pub fn weekday_to_int(weekday: Weekday) -> Int {
  case weekday {
    Monday -> 1
    Tuesday -> 2
    Wednesday -> 3
    Thursday -> 4
    Friday -> 5
    Saturday -> 6
    Sunday -> 7
  }
}

/// Returns the weekday for a given number, where Monday is 1 and Sunday
/// is 7, following ISO 8601.
///
/// ## Examples
///
/// ```gleam
/// weekday_from_int(1)
/// // -> Ok(Monday)
/// ```
///
pub fn weekday_from_int(weekday: Int) -> Result(Weekday, Nil) {
  case weekday {
    1 -> Ok(Monday)
    2 -> Ok(Tuesday)
    3 -> Ok(Wednesday)
    4 -> Ok(Thursday)
    5 -> Ok(Friday)
    6 -> Ok(Saturday)
    7 -> Ok(Sunday)
    _ -> Error(Nil)
  }
}

/// Returns the timestamp as an RFC 7231 string (e.g.,
/// `"Thu, 01 Jan 1970 00:00:00 GMT"`). This is the format used by HTTP
/// `Date`, `Last-Modified`, and `Expires` headers. Equivalent to
/// JavaScript's `Date.prototype.toUTCString`.
///
@external(javascript, "./time_extra.ffi.mjs", "to_utc_string")
pub fn to_utc_string(timestamp: Timestamp) -> String

/// Returns the day of the week for the given offset. Pass
/// `gleam/time/calendar.utc_offset` for UTC or
/// `gleam/time/calendar.local_offset()` for the host's local timezone.
/// Equivalent to JavaScript's `Date.prototype.getDay`.
///
@external(javascript, "./time_extra.ffi.mjs", "day_of_week")
pub fn day_of_week(timestamp: Timestamp, offset: Duration) -> Weekday
