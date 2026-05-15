import gleam/list
import gleam/option.{None, Some}
import gleeunit/should
import gossamer/intl
import gossamer/intl/locale

fn at(tag: String) -> locale.Locale {
  let assert Ok(l) = locale.new(tag) |> locale.build
  l
}

pub fn build_default_test() {
  locale.new("en-US") |> locale.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  locale.new("not_a_locale!") |> locale.build |> should.be_error
}

pub fn info_base_name_test() {
  locale.info(at("en-US-u-ca-gregory")).base_name |> should.equal("en-US")
}

pub fn info_language_test() {
  locale.info(at("en-US")).language |> should.equal("en")
}

pub fn info_region_present_test() {
  locale.info(at("en-US")).region |> should.equal(Some("US"))
}

pub fn info_region_absent_test() {
  locale.info(at("en")).region |> should.equal(None)
}

pub fn info_script_present_test() {
  locale.info(at("zh-Hans-CN")).script |> should.equal(Some("Hans"))
}

pub fn info_script_absent_test() {
  locale.info(at("en-US")).script |> should.equal(None)
}

pub fn info_calendar_present_test() {
  locale.info(at("en-US-u-ca-gregory")).calendar
  |> should.equal(Some("gregory"))
}

pub fn info_calendar_absent_test() {
  locale.info(at("en-US")).calendar |> should.equal(None)
}

pub fn info_case_first_upper_test() {
  locale.info(at("en-US-u-kf-upper")).case_first
  |> should.equal(Some(intl.Upper))
}

pub fn info_case_first_absent_test() {
  locale.info(at("en-US")).case_first |> should.equal(None)
}

pub fn info_collation_present_test() {
  locale.info(at("de-DE-u-co-phonebk")).collation
  |> should.equal(Some("phonebk"))
}

pub fn info_collation_absent_test() {
  locale.info(at("en-US")).collation |> should.equal(None)
}

pub fn info_hour_cycle_present_test() {
  locale.info(at("en-US-u-hc-h23")).hour_cycle |> should.equal(Some(intl.H23))
}

pub fn info_hour_cycle_absent_test() {
  locale.info(at("en-US")).hour_cycle |> should.equal(None)
}

pub fn info_numbering_system_present_test() {
  locale.info(at("en-US-u-nu-latn")).numbering_system
  |> should.equal(Some("latn"))
}

pub fn info_numbering_system_absent_test() {
  locale.info(at("en-US")).numbering_system |> should.equal(None)
}

pub fn info_is_numeric_true_test() {
  locale.info(at("en-US-u-kn-true")).is_numeric |> should.be_true
}

pub fn info_is_numeric_default_test() {
  locale.info(at("en-US")).is_numeric |> should.be_false
}

pub fn calendars_test() {
  locale.calendars(at("en-US"))
  |> list.contains("gregory")
  |> should.be_true
}

pub fn collations_test() {
  // Every locale returns at least the default "emoji" / "eor" collations.
  { locale.collations(at("en-US")) != [] } |> should.be_true
}

pub fn hour_cycles_test() {
  // en-US prefers h12; the list is non-empty and contains HourCycle values.
  case locale.hour_cycles(at("en-US")) {
    [_, ..] -> Nil
    [] -> panic as "expected non-empty hour cycles"
  }
}

pub fn numbering_systems_test() {
  locale.numbering_systems(at("en-US"))
  |> list.contains("latn")
  |> should.be_true
}

pub fn time_zones_with_region_test() {
  case locale.time_zones(at("en-US")) {
    Ok(zones) -> zones |> list.contains("America/New_York") |> should.be_true
    Error(Nil) -> panic as "expected time zones for a region locale"
  }
}

pub fn time_zones_without_region_test() {
  locale.time_zones(at("en")) |> should.be_error
}

pub fn text_direction_ltr_test() {
  locale.text_direction(at("en-US")) |> should.equal(locale.Ltr)
}

pub fn text_direction_rtl_test() {
  locale.text_direction(at("ar")) |> should.equal(locale.Rtl)
}

pub fn week_info_test() {
  let info = locale.week_info(at("en-US"))
  // en-US starts the week on Sunday (7) cross-runtime.
  info.first_day |> should.equal(7)
  info.weekend |> should.equal([6, 7])
}

pub fn maximize_test() {
  let maximized = locale.maximize(at("en"))
  locale.to_string(maximized) |> should.equal("en-Latn-US")
}

pub fn minimize_test() {
  let minimized = locale.minimize(at("en-Latn-US"))
  locale.to_string(minimized) |> should.equal("en")
}

pub fn to_string_test() {
  locale.to_string(at("en-US-u-ca-gregory"))
  |> should.equal("en-US-u-ca-gregory")
}

pub fn with_calendar_override_test() {
  let assert Ok(loc) =
    locale.new("en-US") |> locale.with_calendar("buddhist") |> locale.build
  locale.info(loc).calendar |> should.equal(Some("buddhist"))
}

pub fn with_hour_cycle_override_test() {
  let assert Ok(loc) =
    locale.new("en-US") |> locale.with_hour_cycle(intl.H23) |> locale.build
  locale.info(loc).hour_cycle |> should.equal(Some(intl.H23))
}

pub fn with_region_override_test() {
  let assert Ok(loc) =
    locale.new("en") |> locale.with_region("GB") |> locale.build
  locale.info(loc).region |> should.equal(Some("GB"))
}
