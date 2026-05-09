//// JavaScript runtime extras layered on top of `gleam/time/timestamp`.
////
//// Covers locale-aware string formatting, RFC 7231 HTTP date strings,
//// and day-of-week — none of which `gleam_time` exposes itself.
////

import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}

/// Returns a locale-sensitive string representing the full date and time.
///
@external(javascript, "./time_extra.ffi.mjs", "to_locale_string")
pub fn to_locale_string(timestamp: Timestamp) -> String

/// Returns a locale-sensitive string representing the date portion.
///
@external(javascript, "./time_extra.ffi.mjs", "to_locale_date_string")
pub fn to_locale_date_string(timestamp: Timestamp) -> String

/// Returns a locale-sensitive string representing the time portion.
///
@external(javascript, "./time_extra.ffi.mjs", "to_locale_time_string")
pub fn to_locale_time_string(timestamp: Timestamp) -> String

/// Returns the timestamp as an RFC 7231 string (e.g.,
/// `"Thu, 01 Jan 1970 00:00:00 GMT"`). This is the format used by HTTP
/// `Date`, `Last-Modified`, and `Expires` headers.
///
@external(javascript, "./time_extra.ffi.mjs", "to_utc_string")
pub fn to_utc_string(timestamp: Timestamp) -> String

/// Returns the day of the week (`0`–`6`, where `0` is Sunday) for the
/// given offset. Pass `gleam/time/calendar.utc_offset` for UTC or
/// `gleam/time/calendar.local_offset()` for the host's local timezone.
///
@external(javascript, "./time_extra.ffi.mjs", "day_of_week")
pub fn day_of_week(timestamp: Timestamp, offset: Duration) -> Int
