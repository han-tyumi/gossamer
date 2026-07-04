import * as $time_extra from "$/gossamer/gossamer/time_extra.mjs";

const WEEKDAYS = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

const MONTHS = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

// Floored division with an exact remainder: the float quotient of two
// large safe integers can round across an integer boundary, so the
// result is corrected against the exact remainder.
function floorDiv(dividend: number, divisor: number): number {
  let quotient = Math.floor(dividend / divisor);
  const remainder = dividend - quotient * divisor;
  if (remainder < 0) quotient -= 1;
  if (remainder >= divisor) quotient += 1;
  return quotient;
}

// Proleptic-Gregorian civil date from days since the Unix epoch, exact
// for the full range of safe-integer seconds.
function civilFromDays(days: number): [number, number, number] {
  const shifted = days + 719_468;
  const era = floorDiv(shifted, 146_097);
  const dayOfEra = shifted - era * 146_097;
  const yearOfEra = floorDiv(
    dayOfEra - floorDiv(dayOfEra, 1460) + floorDiv(dayOfEra, 36_524) -
      floorDiv(dayOfEra, 146_096),
    365,
  );
  const dayOfYear = dayOfEra -
    (365 * yearOfEra + floorDiv(yearOfEra, 4) - floorDiv(yearOfEra, 100));
  const monthPoint = floorDiv(5 * dayOfYear + 2, 153);
  const day = dayOfYear - floorDiv(153 * monthPoint + 2, 5) + 1;
  const month = monthPoint < 10 ? monthPoint + 3 : monthPoint - 9;
  const year = yearOfEra + era * 400 + (month <= 2 ? 1 : 0);
  return [year, month, day];
}

function pad2(value: number): string {
  return String(value).padStart(2, "0");
}

// 1970-01-01 was a Thursday; result matches Date.prototype.getUTCDay.
function utcDayNumber(days: number): number {
  return ((days % 7) + 11) % 7;
}

export const to_utc_string: typeof $time_extra.do_to_utc_string = (
  unixSeconds,
) => {
  const days = floorDiv(unixSeconds, 86_400);
  const secondOfDay = unixSeconds - days * 86_400;
  const [year, month, day] = civilFromDays(days);
  const yearSign = year < 0 ? "-" : "";
  const paddedYear = String(Math.abs(year)).padStart(4, "0");
  const hours = Math.floor(secondOfDay / 3600);
  const minutes = Math.floor(secondOfDay / 60) % 60;
  const seconds = secondOfDay % 60;
  return `${WEEKDAYS[utcDayNumber(days)]}, ${pad2(day)} ${
    MONTHS[month - 1]
  } ${yearSign}${paddedYear} ${pad2(hours)}:${pad2(minutes)}:${
    pad2(seconds)
  } GMT`;
};

export const day_of_week: typeof $time_extra.do_day_of_week = (
  unixSeconds,
) => {
  switch (utcDayNumber(floorDiv(unixSeconds, 86_400))) {
    case 0:
      return $time_extra.Weekday$Sunday();
    case 1:
      return $time_extra.Weekday$Monday();
    case 2:
      return $time_extra.Weekday$Tuesday();
    case 3:
      return $time_extra.Weekday$Wednesday();
    case 4:
      return $time_extra.Weekday$Thursday();
    case 5:
      return $time_extra.Weekday$Friday();
    default:
      return $time_extra.Weekday$Saturday();
  }
};
