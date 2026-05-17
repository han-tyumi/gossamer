import * as $segmenter from "$/gossamer/gossamer/intl/segmenter.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { jsIteratorAsYielder } from "~/gossamer/iteration.ffi.ts";
import { toLocaleMatcher } from "~/utils/intl.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, toOption } from "~/utils/option.ffi.ts";

function toGranularity(
  granularity: $segmenter.Granularity$,
): "grapheme" | "word" | "sentence" {
  if ($segmenter.Granularity$isGrapheme(granularity)) return "grapheme";
  if ($segmenter.Granularity$isWord(granularity)) return "word";
  return "sentence";
}

function toSegment(data: Intl.SegmentData): $segmenter.Segment$ {
  return $segmenter.Segment$Segment(
    data.segment,
    data.index,
    toOption(data.isWordLike),
  );
}

export const build: typeof $segmenter.do_build = (
  locales,
  locale_matcher,
  granularity,
) => {
  const options: Intl.SegmenterOptions = {};
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
  mapIfSome(options, "granularity", granularity, toGranularity);
  try {
    return Result$Ok(new Intl.Segmenter(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const segment: typeof $segmenter.segment = (segmenter, input) => {
  const segments = segmenter.segment(input);
  const jsIterator = segments[Symbol.iterator]();
  const mappedIterator: Iterator<$segmenter.Segment$, undefined, undefined> = {
    next() {
      const result = jsIterator.next();
      if (result.done) return { done: true as const, value: undefined };
      return { done: false as const, value: toSegment(result.value) };
    },
  };
  return jsIteratorAsYielder(mappedIterator);
};

export const resolved_locale: typeof $segmenter.resolved_locale = (
  segmenter,
) => {
  return segmenter.resolvedOptions().locale;
};

export const supported_locales_of: typeof $segmenter.supported_locales_of = (
  locales,
) => {
  return fromArray(Intl.Segmenter.supportedLocalesOf(toArray(locales)));
};
