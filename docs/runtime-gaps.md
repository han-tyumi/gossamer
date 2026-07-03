# Runtime gaps

Known cross-runtime gaps in gossamer's bindings. Per-binding doc comments flag
these inline; this page is the consolidated view.

The minimum runtime versions where gossamer's test suite passes are visible as
badges on the [README](https://github.com/han-tyumi/gossamer#gossamer-). Older
versions than those are considered unsupported.

## Bun

- **`readable_stream.from_yielder` / `from_async_yielder`** — panics via the
  FFI's `ensureMethod` guard. `ReadableStream.from` is not implemented on Bun.
  Tracked at [oven-sh/bun#3700](https://github.com/oven-sh/bun/issues/3700).
- **`text_decoder.build` / `text_decoder_stream.build`** with legacy single-byte
  encodings — return `Error(UnsupportedEncoding)` for 16 encodings Bun's ICU
  data omits (`iso-8859-2`, `-4`, `-5`, `-10`, `-13`, `-14`, `-15`, `-16`,
  `koi8-r`, `macintosh`, `windows-1250`, `-1251`, `-1254`, `-1256`, `-1258`,
  `x-mac-cyrillic`). Node and Deno construct them. UTF-8 and both UTF-16 byte
  orders work everywhere.
- **`crypto/subtle.derive_bits`** with `length: 0` — resolves with the full
  shared secret instead of an empty `BitArray`. Node and Deno resolve with an
  empty result. Fixed upstream in
  [oven-sh/bun#32819](https://github.com/oven-sh/bun/pull/32819); not yet in a
  Bun release.
- **`fetch_extra.response_type`** — returns `ResponseDefault` for synthetic
  responses (e.g. `Response("body")`) where the Fetch spec, Node, and Deno
  return `ResponseBasic`.
- **`plural_rules.resolved_options`** — its `locale` field keeps full input tags
  like `"en-US"`. Node and Deno normalize the same input to `"en"`. Other Intl
  formatters (`number_format`, etc.) keep `"en-US"` across all three.
- **`date_time_format.format_to_parts`** for the Chinese calendar
  (`zh-u-ca-chinese`) with year-only options — omits the `RelatedYear` segment
  that Node and Deno emit before `YearName`. Option sets that include a month or
  day emit `RelatedYear` on all three runtimes.
- **`date_time_format.format_range`** — uses regular U+0020 spaces around the en
  dash. Node and Deno use thin (U+2009) spaces. Assert via substring rather than
  strict equality if you compare formatted output across runtimes.

## Node.js

- **`abort_signal.timeout(duration)`** — panics with
  `RangeError: The value of "delay" is out of range` for durations longer than
  `4_294_967_295` ms (~49.7 days, the u32 max). Deno and Bun accept values up to
  `Int`'s safe range.

## All three runtimes

- **`plural_rules.select` with `BigInt`** — all three runtimes throw `TypeError`
  despite the ES2023 spec allowing `BigInt` inputs. gossamer doesn't expose the
  `BigInt` overload of `select`; convert via
  [`big_int.to_int`](./gossamer/big_int.html#to_int) first when the value fits
  in `Int`'s safe range.

## Browsers

gossamer's source targets the current evergreen baseline (Chromium, Firefox,
Safari). Browser-specific gaps would be noted here as they're encountered. CI
verifies against Node.js, Deno, and Bun only.

## See also

- [Conventions](./conventions.html) — gossamer's API patterns.
- [Coverage](./coverage.html) — what gossamer wraps.
- [Contributing](https://github.com/han-tyumi/gossamer/blob/main/CONTRIBUTING.md)
  — how gossamer's FFI handles divergence (Pattern 1: spec default at the FFI
  boundary; Pattern 2: diagnostic FFI throw).
