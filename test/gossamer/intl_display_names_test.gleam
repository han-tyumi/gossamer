import gleam/option.{Some}
import gleeunit/should
import gossamer/intl
import gossamer/intl/display_names

pub fn build_default_test() {
  display_names.new([], of: display_names.Language)
  |> display_names.build
  |> should.be_ok
}

pub fn build_invalid_locale_test() {
  display_names.new(["not_a_locale!"], of: display_names.Language)
  |> display_names.build
  |> should.be_error
}

pub fn of_language_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Language)
    |> display_names.build
  display_names.of(formatter, "fr") |> should.equal(Ok("French"))
}

pub fn of_region_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Region)
    |> display_names.build
  display_names.of(formatter, "US") |> should.equal(Ok("United States"))
}

pub fn of_script_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Script)
    |> display_names.build
  display_names.of(formatter, "Latn") |> should.equal(Ok("Latin"))
}

pub fn of_currency_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Currency)
    |> display_names.build
  display_names.of(formatter, "USD") |> should.equal(Ok("US Dollar"))
}

pub fn of_calendar_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Calendar)
    |> display_names.build
  display_names.of(formatter, "gregory")
  |> should.equal(Ok("Gregorian Calendar"))
}

pub fn of_date_time_field_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.DateTimeField)
    |> display_names.build
  display_names.of(formatter, "year") |> should.equal(Ok("year"))
}

pub fn of_short_style_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Region)
    |> display_names.with_style(intl.Short)
    |> display_names.build
  display_names.of(formatter, "US") |> should.equal(Ok("US"))
}

pub fn of_unknown_falls_back_to_code_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Language)
    |> display_names.build
  display_names.of(formatter, "zz") |> should.equal(Ok("zz"))
}

pub fn find_known_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Language)
    |> display_names.build
  display_names.find(formatter, "fr") |> should.equal(Ok("French"))
}

pub fn find_unknown_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Language)
    |> display_names.build
  display_names.find(formatter, "zz") |> should.be_error
}

pub fn of_malformed_code_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Region)
    |> display_names.build
  display_names.of(formatter, "not a code!") |> should.be_error
}

pub fn find_malformed_code_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Region)
    |> display_names.build
  display_names.find(formatter, "not a code!") |> should.be_error
}

pub fn language_display_dialect_test() {
  let assert Ok(formatter) =
    display_names.new(["en"], of: display_names.Language)
    |> display_names.with_language_display(display_names.Dialect)
    |> display_names.build
  display_names.of(formatter, "en-US")
  |> should.equal(Ok("American English"))
}

pub fn language_display_differs_test() {
  let assert Ok(dialect) =
    display_names.new(["en"], of: display_names.Language)
    |> display_names.with_language_display(display_names.Dialect)
    |> display_names.build
  let assert Ok(standard) =
    display_names.new(["en"], of: display_names.Language)
    |> display_names.with_language_display(display_names.Standard)
    |> display_names.build
  let dialect_name = display_names.of(dialect, "en-US")
  let standard_name = display_names.of(standard, "en-US")
  { dialect_name != standard_name } |> should.be_true
}

pub fn resolved_options_test() {
  let assert Ok(formatter) =
    display_names.new(["en-US"], of: display_names.Language)
    |> display_names.with_style(intl.Short)
    |> display_names.with_language_display(display_names.Standard)
    |> display_names.build
  let options = display_names.resolved_options(formatter)
  options.locale |> should.equal("en-US")
  options.kind |> should.equal(display_names.Language)
  options.style |> should.equal(intl.Short)
  options.language_display |> should.equal(Some(display_names.Standard))
}

pub fn supported_locales_of_test() {
  display_names.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(Ok(["en-US"]))
}

pub fn supported_locales_of_malformed_tag_test() {
  display_names.supported_locales_of(["not_a_locale!"])
  |> should.be_error
}
