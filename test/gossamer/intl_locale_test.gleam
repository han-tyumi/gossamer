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

pub fn base_name_test() {
  locale.base_name(at("en-US-u-ca-gregory")) |> should.equal("en-US")
}

pub fn language_test() {
  locale.language(at("en-US")) |> should.equal("en")
}

pub fn region_present_test() {
  locale.region(at("en-US")) |> should.equal(Some("US"))
}

pub fn region_absent_test() {
  locale.region(at("en")) |> should.equal(None)
}

pub fn script_present_test() {
  locale.script(at("zh-Hans-CN")) |> should.equal(Some("Hans"))
}

pub fn script_absent_test() {
  locale.script(at("en-US")) |> should.equal(None)
}

pub fn calendar_present_test() {
  locale.calendar(at("en-US-u-ca-gregory")) |> should.equal(Some("gregory"))
}

pub fn calendar_absent_test() {
  locale.calendar(at("en-US")) |> should.equal(None)
}

pub fn case_first_upper_test() {
  locale.case_first(at("en-US-u-kf-upper")) |> should.equal(Some(intl.Upper))
}

pub fn case_first_absent_test() {
  locale.case_first(at("en-US")) |> should.equal(None)
}

pub fn collation_present_test() {
  locale.collation(at("de-DE-u-co-phonebk")) |> should.equal(Some("phonebk"))
}

pub fn collation_absent_test() {
  locale.collation(at("en-US")) |> should.equal(None)
}

pub fn hour_cycle_present_test() {
  locale.hour_cycle(at("en-US-u-hc-h23")) |> should.equal(Some(intl.H23))
}

pub fn hour_cycle_absent_test() {
  locale.hour_cycle(at("en-US")) |> should.equal(None)
}

pub fn numbering_system_present_test() {
  locale.numbering_system(at("en-US-u-nu-latn")) |> should.equal(Some("latn"))
}

pub fn numbering_system_absent_test() {
  locale.numbering_system(at("en-US")) |> should.equal(None)
}

pub fn numeric_true_test() {
  locale.numeric(at("en-US-u-kn-true")) |> should.be_true
}

pub fn numeric_default_test() {
  locale.numeric(at("en-US")) |> should.be_false
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
    Some(zones) -> zones |> list.contains("America/New_York") |> should.be_true
    None -> panic as "expected time zones for a region locale"
  }
}

pub fn time_zones_without_region_test() {
  locale.time_zones(at("en")) |> should.equal(None)
}

pub fn text_info_ltr_test() {
  locale.text_info(at("en-US"))
  |> should.equal(locale.TextInfo(locale.Ltr))
}

pub fn text_info_rtl_test() {
  locale.text_info(at("ar"))
  |> should.equal(locale.TextInfo(locale.Rtl))
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
  locale.calendar(loc) |> should.equal(Some("buddhist"))
}

pub fn with_hour_cycle_override_test() {
  let assert Ok(loc) =
    locale.new("en-US") |> locale.with_hour_cycle(intl.H23) |> locale.build
  locale.hour_cycle(loc) |> should.equal(Some(intl.H23))
}

pub fn with_region_override_test() {
  let assert Ok(loc) =
    locale.new("en") |> locale.with_region("GB") |> locale.build
  locale.region(loc) |> should.equal(Some("GB"))
}
