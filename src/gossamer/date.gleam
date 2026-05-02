import gossamer/js_error.{type JsError}

/// A point in time, represented as milliseconds since the Unix epoch.
///
/// See [Date](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date) on MDN.
///
@external(javascript, "./date.type.ts", "Date$")
pub type Date

/// Returns a new `Date` representing the current date and time.
///
@external(javascript, "./date.ffi.mjs", "new_")
pub fn new() -> Date

/// Returns a new `Date` from the given number of milliseconds since the Unix
/// epoch (January 1, 1970 00:00:00 UTC).
///
@external(javascript, "./date.ffi.mjs", "from_time")
pub fn from_time(time: Int) -> Date

/// Parses a date string and returns a new `Date`. Returns an error if the
/// string cannot be parsed as a valid date. Only ISO 8601 format (e.g.,
/// "2026-04-09T14:30:00.000Z") is reliably parsed across all runtimes.
///
@external(javascript, "./date.ffi.mjs", "from_string")
pub fn from_string(string: String) -> Result(Date, Nil)

/// Returns the current timestamp in milliseconds since the Unix epoch.
///
@external(javascript, "./date.ffi.mjs", "now")
pub fn now() -> Int

/// Parses a date string and returns the corresponding timestamp in
/// milliseconds. Returns an error if the string cannot be parsed. Only
/// ISO 8601 format is reliably parsed across all runtimes.
///
@external(javascript, "./date.ffi.mjs", "parse")
pub fn parse(string: String) -> Result(Int, Nil)

/// Returns the number of milliseconds since the Unix epoch.
///
@external(javascript, "./date.ffi.mjs", "time")
pub fn time(of date: Date) -> Int

/// Returns the four-digit year according to local time.
///
@external(javascript, "./date.ffi.mjs", "full_year")
pub fn full_year(of date: Date) -> Int

/// Returns the zero-based month (0–11) according to local time.
///
@external(javascript, "./date.ffi.mjs", "month")
pub fn month(of date: Date) -> Int

/// Returns the day of the month (1–31) according to local time.
///
@external(javascript, "./date.ffi.mjs", "date")
pub fn date(of date: Date) -> Int

/// Returns the day of the week (0–6, where 0 is Sunday) according to local
/// time.
///
@external(javascript, "./date.ffi.mjs", "day")
pub fn day(of date: Date) -> Int

/// Returns the hour (0–23) according to local time.
///
@external(javascript, "./date.ffi.mjs", "hours")
pub fn hours(of date: Date) -> Int

/// Returns the minutes (0–59) according to local time.
///
@external(javascript, "./date.ffi.mjs", "minutes")
pub fn minutes(of date: Date) -> Int

/// Returns the seconds (0–59) according to local time.
///
@external(javascript, "./date.ffi.mjs", "seconds")
pub fn seconds(of date: Date) -> Int

/// Returns the milliseconds (0–999) according to local time.
///
@external(javascript, "./date.ffi.mjs", "milliseconds")
pub fn milliseconds(of date: Date) -> Int

/// Returns the four-digit year according to UTC.
///
@external(javascript, "./date.ffi.mjs", "utc_full_year")
pub fn utc_full_year(of date: Date) -> Int

/// Returns the zero-based month (0–11) according to UTC.
///
@external(javascript, "./date.ffi.mjs", "utc_month")
pub fn utc_month(of date: Date) -> Int

/// Returns the day of the month (1–31) according to UTC.
///
@external(javascript, "./date.ffi.mjs", "utc_date")
pub fn utc_date(of date: Date) -> Int

/// Returns the day of the week (0–6, where 0 is Sunday) according to UTC.
///
@external(javascript, "./date.ffi.mjs", "utc_day")
pub fn utc_day(of date: Date) -> Int

/// Returns the hour (0–23) according to UTC.
///
@external(javascript, "./date.ffi.mjs", "utc_hours")
pub fn utc_hours(of date: Date) -> Int

/// Returns the minutes (0–59) according to UTC.
///
@external(javascript, "./date.ffi.mjs", "utc_minutes")
pub fn utc_minutes(of date: Date) -> Int

/// Returns the seconds (0–59) according to UTC.
///
@external(javascript, "./date.ffi.mjs", "utc_seconds")
pub fn utc_seconds(of date: Date) -> Int

/// Returns the milliseconds (0–999) according to UTC.
///
@external(javascript, "./date.ffi.mjs", "utc_milliseconds")
pub fn utc_milliseconds(of date: Date) -> Int

/// Returns the difference, in minutes, between UTC and local time. The value
/// is positive if the local time zone is behind UTC and negative if ahead.
///
@external(javascript, "./date.ffi.mjs", "timezone_offset")
pub fn timezone_offset(of date: Date) -> Int

/// Sets the number of milliseconds since the Unix epoch. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_time")
pub fn set_time(of date: Date, to time: Int) -> Date

/// Sets the four-digit year according to local time. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_full_year")
pub fn set_full_year(of date: Date, to year: Int) -> Date

/// Sets the zero-based month (0–11) according to local time. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_month")
pub fn set_month(of date: Date, to month: Int) -> Date

/// Sets the day of the month according to local time. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_date")
pub fn set_date(of date: Date, to day: Int) -> Date

/// Sets the hour (0–23) according to local time. Mutates the date in-place.
///
@external(javascript, "./date.ffi.mjs", "set_hours")
pub fn set_hours(of date: Date, to hours: Int) -> Date

/// Sets the minutes (0–59) according to local time. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_minutes")
pub fn set_minutes(of date: Date, to minutes: Int) -> Date

/// Sets the seconds (0–59) according to local time. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_seconds")
pub fn set_seconds(of date: Date, to seconds: Int) -> Date

/// Sets the milliseconds (0–999) according to local time. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_milliseconds")
pub fn set_milliseconds(of date: Date, to milliseconds: Int) -> Date

/// Sets the four-digit year according to UTC. Mutates the date in-place.
///
@external(javascript, "./date.ffi.mjs", "set_utc_full_year")
pub fn set_utc_full_year(of date: Date, to year: Int) -> Date

/// Sets the zero-based month (0–11) according to UTC. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_utc_month")
pub fn set_utc_month(of date: Date, to month: Int) -> Date

/// Sets the day of the month according to UTC. Mutates the date in-place.
///
@external(javascript, "./date.ffi.mjs", "set_utc_date")
pub fn set_utc_date(of date: Date, to day: Int) -> Date

/// Sets the hour (0–23) according to UTC. Mutates the date in-place.
///
@external(javascript, "./date.ffi.mjs", "set_utc_hours")
pub fn set_utc_hours(of date: Date, to hours: Int) -> Date

/// Sets the minutes (0–59) according to UTC. Mutates the date in-place.
///
@external(javascript, "./date.ffi.mjs", "set_utc_minutes")
pub fn set_utc_minutes(of date: Date, to minutes: Int) -> Date

/// Sets the seconds (0–59) according to UTC. Mutates the date in-place.
///
@external(javascript, "./date.ffi.mjs", "set_utc_seconds")
pub fn set_utc_seconds(of date: Date, to seconds: Int) -> Date

/// Sets the milliseconds (0–999) according to UTC. Mutates the date
/// in-place.
///
@external(javascript, "./date.ffi.mjs", "set_utc_milliseconds")
pub fn set_utc_milliseconds(of date: Date, to milliseconds: Int) -> Date

/// Returns a string representing the date using a runtime-dependent format.
///
@external(javascript, "./date.ffi.mjs", "to_string")
pub fn to_string(date: Date) -> String

/// Returns the date portion as a human-readable string (e.g.,
/// "Thu Apr 09 2026").
///
@external(javascript, "./date.ffi.mjs", "to_date_string")
pub fn to_date_string(date: Date) -> String

/// Returns the time portion as a human-readable string (e.g.,
/// "14:30:00 GMT+0000").
///
@external(javascript, "./date.ffi.mjs", "to_time_string")
pub fn to_time_string(date: Date) -> String

/// Returns the date as an ISO 8601 string (e.g.,
/// "2026-04-09T14:30:00.000Z"). Returns an error if the date is invalid.
///
@external(javascript, "./date.ffi.mjs", "to_iso_string")
pub fn to_iso_string(date: Date) -> Result(String, JsError)

/// Returns the date as a UTC string (e.g.,
/// "Thu, 09 Apr 2026 14:30:00 GMT").
///
@external(javascript, "./date.ffi.mjs", "to_utc_string")
pub fn to_utc_string(date: Date) -> String

/// Returns the date as an ISO 8601 string, suitable for JSON serialization.
/// Returns an error if the date is invalid.
///
@external(javascript, "./date.ffi.mjs", "to_json")
pub fn to_json(date: Date) -> Result(String, JsError)

/// Returns a locale-sensitive string representing the full date and time.
///
@external(javascript, "./date.ffi.mjs", "to_locale_string")
pub fn to_locale_string(date: Date) -> String

/// Returns a locale-sensitive string representing the date portion.
///
@external(javascript, "./date.ffi.mjs", "to_locale_date_string")
pub fn to_locale_date_string(date: Date) -> String

/// Returns a locale-sensitive string representing the time portion.
///
@external(javascript, "./date.ffi.mjs", "to_locale_time_string")
pub fn to_locale_time_string(date: Date) -> String
