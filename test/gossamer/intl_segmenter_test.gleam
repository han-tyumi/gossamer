import gleam/list
import gleam/option.{None, Some}
import gleam/yielder
import gleeunit/should
import gossamer/intl/segmenter

fn segments(
  of seg: segmenter.Segmenter,
  in input: String,
) -> List(segmenter.Segment) {
  segmenter.segment(seg, input) |> yielder.to_list
}

pub fn build_default_test() {
  segmenter.new([]) |> segmenter.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  segmenter.new(["not_a_locale!"])
  |> segmenter.build
  |> should.be_error
}

pub fn segment_grapheme_test() {
  let assert Ok(seg) = segmenter.new(["en"]) |> segmenter.build
  segments(of: seg, in: "ábc")
  |> list.map(fn(s) { s.value })
  |> should.equal(["á", "b", "c"])
}

pub fn segment_word_test() {
  let assert Ok(seg) =
    segmenter.new(["en"])
    |> segmenter.with_granularity(segmenter.Word)
    |> segmenter.build
  segments(of: seg, in: "Hello, world!")
  |> list.map(fn(s) { s.value })
  |> should.equal(["Hello", ",", " ", "world", "!"])
}

pub fn segment_sentence_test() {
  let assert Ok(seg) =
    segmenter.new(["en"])
    |> segmenter.with_granularity(segmenter.Sentence)
    |> segmenter.build
  segments(of: seg, in: "Hi! How are you?")
  |> list.map(fn(s) { s.value })
  |> should.equal(["Hi! ", "How are you?"])
}

pub fn segment_index_test() {
  let assert Ok(seg) = segmenter.new(["en"]) |> segmenter.build
  segments(of: seg, in: "abc")
  |> list.map(fn(s) { s.index })
  |> should.equal([0, 1, 2])
}

pub fn word_like_some_for_word_test() {
  let assert Ok(seg) =
    segmenter.new(["en"])
    |> segmenter.with_granularity(segmenter.Word)
    |> segmenter.build
  let parts = segments(of: seg, in: "Hello, world!")
  case parts {
    [first, ..] -> first.word_like |> should.equal(Some(True))
    [] -> panic as "expected non-empty segments"
  }
}

pub fn word_like_distinguishes_punctuation_test() {
  let assert Ok(seg) =
    segmenter.new(["en"])
    |> segmenter.with_granularity(segmenter.Word)
    |> segmenter.build
  segments(of: seg, in: "Hi,")
  |> list.map(fn(s) { s.word_like })
  |> should.equal([Some(True), Some(False)])
}

pub fn word_like_none_for_grapheme_test() {
  let assert Ok(seg) = segmenter.new(["en"]) |> segmenter.build
  case segments(of: seg, in: "abc") {
    [first, ..] -> first.word_like |> should.equal(None)
    [] -> panic as "expected non-empty segments"
  }
}

pub fn word_like_none_for_sentence_test() {
  let assert Ok(seg) =
    segmenter.new(["en"])
    |> segmenter.with_granularity(segmenter.Sentence)
    |> segmenter.build
  case segments(of: seg, in: "Hi.") {
    [first, ..] -> first.word_like |> should.equal(None)
    [] -> panic as "expected non-empty segments"
  }
}

pub fn segment_empty_input_test() {
  let assert Ok(seg) = segmenter.new(["en"]) |> segmenter.build
  segments(of: seg, in: "") |> should.equal([])
}

pub fn resolved_locale_test() {
  let assert Ok(seg) = segmenter.new(["en-US"]) |> segmenter.build
  segmenter.resolved_locale(seg) |> should.equal("en-US")
}

pub fn supported_locales_of_test() {
  segmenter.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(["en-US"])
}
