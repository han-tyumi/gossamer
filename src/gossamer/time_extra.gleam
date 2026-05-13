//// Extras for `gleam/time/timestamp` — RFC 7231 HTTP date-header
//// strings and day-of-week, neither of which `gleam_time` exposes
//// itself.

import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}

/// A day of the week. Mirrors the shape of
/// [`gleam/time/calendar.Month`](https://hexdocs.pm/gleam_time/gleam/time/calendar.html#Month).
///
pub type Weekday {
  Sunday
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
}

/// Returns the timestamp as an RFC 7231 string (e.g.,
/// `"Thu, 01 Jan 1970 00:00:00 GMT"`). This is the format used by HTTP
/// `Date`, `Last-Modified`, and `Expires` headers.
///
@external(javascript, "./time_extra.ffi.mjs", "to_utc_string")
pub fn to_utc_string(timestamp: Timestamp) -> String

/// Returns the day of the week for the given offset. Pass
/// `gleam/time/calendar.utc_offset` for UTC or
/// `gleam/time/calendar.local_offset()` for the host's local timezone.
///
@external(javascript, "./time_extra.ffi.mjs", "day_of_week")
pub fn day_of_week(timestamp: Timestamp, offset: Duration) -> Weekday
