## 10.0.0 (2026-07-04)

v10 is a ground-up reshape around two principles: lean on the Gleam ecosystem
where it already covers a Web API, and focus gossamer on filling the gaps the
spec leaves. Nearly every module moved, was renamed, or was dropped in favor of
a canonical type — treat this as a fresh start, not an incremental upgrade.

### Breaking Changes

v10 supports Node.js >= 24.7.0, Deno >= 2.8.2, and Bun >= 1.3.13.

Dropped in favor of existing ecosystem libraries and canonical types:

- Request, Response, Headers, and HTTP methods/statuses are gone — use
  [`gleam_http`](https://hexdocs.pm/gleam_http/) and
  [`gleam_fetch`](https://hexdocs.pm/gleam_fetch/). Fetch configuration they
  don't cover (mode, credentials, cache, redirect, referrer, priority,
  integrity, keepalive, signal) is now in `gossamer/fetch_extra`; File-valued
  form entries are in `gossamer/form_data_extra`.
- URLSearchParams is gone — use
  [`gleam/uri`](https://hexdocs.pm/gleam_stdlib/gleam/uri.html). `gossamer/url`
  now validates and canonicalizes a URL per the WHATWG spec and returns a
  `gleam/uri.Uri`.
- The Date, Promise, Math, Number, String, Symbol, and RegExp bindings are gone
  — use [`gleam/time`](https://hexdocs.pm/gleam_time/),
  [`gleam/javascript/promise`](https://hexdocs.pm/gleam_javascript/gleam/javascript/promise.html),
  [`gleam/float`](https://hexdocs.pm/gleam_stdlib/gleam/float.html),
  [`gleam/int`](https://hexdocs.pm/gleam_stdlib/gleam/int.html),
  [`gleam/string`](https://hexdocs.pm/gleam_stdlib/gleam/string.html),
  [`gleam/javascript/symbol`](https://hexdocs.pm/gleam_javascript/gleam/javascript/symbol.html),
  and [`gleam/regexp`](https://hexdocs.pm/gleam_regexp/). The platform extras
  those libraries don't cover live in `gossamer/time_extra`, `float_extra`,
  `int_extra`, `string_extra`, `symbol_extra`, and `regexp_extra`.
- The Iterator and AsyncIterator bindings are now the top-level
  `gossamer/iterator` and `gossamer/async_iterator` — thin interop types (like
  [`gleam/javascript/array`](https://hexdocs.pm/gleam_javascript/gleam/javascript/array.html))
  that bridge to [`gleam/yielder`](https://hexdocs.pm/gleam_yielder/) and the
  new pure-Gleam `gossamer/async_yielder`.

Dropped entirely:

- The full TypedArray family, keeping only `gossamer/uint8_array` for interop —
  use `BitArray` for byte data and bridge with `to_bit_array` /
  `from_bit_array`.
- The Event family (Event, EventTarget, CustomEvent, ErrorEvent, MessageEvent),
  the WeakMap / WeakSet / WeakRef / FinalizationRegistry bindings, and js_error.

Reorganized into family modules:

- Crypto is now `gossamer/crypto` (the shared types and `random_uuid`) plus
  `crypto/key`, `crypto/subtle`, and `crypto/jwk`, with per-algorithm options as
  typed variants on `crypto/subtle`.
- Text encoding is now `gossamer/encoding/*`; compression is
  `gossamer/compression/*`; the Streams API is `gossamer/stream/*`, with the
  shared lifecycle error and queuing strategy on `gossamer/stream`.

Reshaped within retained bindings:

- AbortController folds into `gossamer/abort_signal` (`new()` returns the signal
  and an abort function); WebSocket's ready state folds into
  `gossamer/web_socket`, and the binary type is gone — binary messages always
  arrive as `Binary(BitArray)` events.
- Numerous shape refinements to match the ecosystem: `desired_size` reports a
  `DesiredSize` variant, `reader.read` returns `Result(Option(a), _)`, the
  digest / compression-stream constructors are infallible, the `run` / `for`
  callback labels are dropped, and `uint8_array.at` and the locale-casing
  functions are relabeled/renamed.
- Fallibility follows the input domain: stream operations report `Locked`
  instead of panicking on locked streams, the intl formatters report errors for
  malformed locale tags/codes and out-of-JS-range timestamps, and
  `web_socket.build` accepts `http:`/`https:` URLs per the current spec.

### Features

- `gossamer/intl` — the [ECMA-402](https://tc39.es/ecma402/) surface: collator,
  date_time_format, number_format, duration_format, relative_time_format,
  list_format, plural_rules, display_names, segmenter, and locale.
- Concurrency: `gossamer/worker`, `gossamer/worker_parent`,
  `gossamer/broadcast_channel`, and message channels/ports with automatic
  MessagePort transfer.
- `gossamer/async_yielder` — a pure-Gleam async-iteration type mirroring
  [`gleam/yielder`](https://hexdocs.pm/gleam_yielder/).
- `gossamer/performance_observer` and the performance/mark and
  performance/measure entry types.

## 9.2.0 (2026-05-04)

### Features

- add from_buffer_range to all 12 typed arrays

## 9.1.0 (2026-05-03)

### Features

- bind DataView
- add from_data_view to Blob and Response
- add WebSocket send_data_view and Request BodyDataView
- add BYOBReader read_data_view
- add SubtleCrypto DataView companions
- add SubtleCrypto ArrayBuffer companions
- add Blob from_buffer constructors

## 9.0.0 (2026-05-03)

### Breaking Changes

- web_socket.send_bytes is renamed to send_typed_array and now takes TypedArray
  instead of Uint8Array. Wrap existing Uint8Array values at the call site:
  web_socket.send_typed_array(ws, typed_array.Uint8(bytes)).
- blob.from_bytes / blob.from_bytes_with_type / response.from_bytes /
  response.from_bytes_with are renamed to from_typed_array /
  from_typed_array_with_type / from_typed_array / from_typed_array_with
  respectively, and now take TypedArray instead of Uint8Array. Wrap existing
  Uint8Array values at the call site, e.g.
  blob.from_typed_array(typed_array.Uint8(bytes)).
- subtle_crypto.digest / encrypt / decrypt / sign / verify / import_key /
  unwrap_key / unwrap_key_jwk now take TypedArray instead of Uint8Array for
  their BufferSource-typed parameters. Wrap existing Uint8Array values at the
  call site, e.g. subtle_crypto.encrypt(algo, key,
  typed_array.Uint8(plaintext)).
- byob_reader.read now takes TypedArray instead of Uint8Array and returns
  ReadResult(TypedArray). Wrap the input view as a TypedArray variant at the
  call site, and pattern-match the result to recover the concrete type.
- crypto.get_random_values now takes IntTypedArray instead of Uint8Array and
  returns IntTypedArray. Wrap the input array as an IntTypedArray variant at the
  call site, e.g. crypto.get_random_values(int_typed_array.Uint8(buffer)), then
  pattern-match the result to recover the concrete type.
- every Uint8Array field on encrypt_algorithm / derive_algorithm /
  wrap_algorithm / key_pair_gen_algorithm now takes TypedArray. Wrap existing
  Uint8Array values at the call site, e.g.
  encrypt_algorithm.AesGcm(typed_array.Uint8(iv)) and
  key_pair_gen_algorithm.Rsa(name, modulus_length,
  typed_array.Uint8(public_exponent), hash).
- request.RequestInit.BodyBytes is renamed to BodyTypedArray and now takes
  TypedArray instead of Uint8Array. Wrap existing Uint8Array values at the call
  site, e.g. request.BodyTypedArray(typed_array.Uint8(bytes)).

### Features

- bind BigInt
- foundation for typed array bindings
- migrate WebSocket to TypedArray
- migrate Blob and Response to TypedArray
- migrate SubtleCrypto to TypedArray
- migrate BYOBReader to TypedArray
- migrate Crypto.get_random_values to IntTypedArray
- migrate SubtleCrypto algorithm types to TypedArray
- migrate Request body bytes to TypedArray

## 8.5.0 (2026-05-02)

### Features

- bind RegExp

## 8.4.0 (2026-05-02)

### Features

- bind ErrorEvent

## 8.3.0 (2026-05-02)

### Features

- bind WeakRef and FinalizationRegistry

## 8.2.0 (2026-05-02)

### Features

- bind WeakMap and WeakSet

## 8.1.0 (2026-05-02)

### Features

- add Fields snapshot to PerformanceEntry, CustomEvent, MessageEvent
- add Fields snapshot to URLPattern
- add Fields snapshot to Blob, File, CryptoKey
- add Fields snapshot to Response
- add Fields snapshot to Request; getters that panicked on Deno/Bun now return
  spec defaults

## 8.0.0 (2026-05-02)

### Breaking Changes

- response.new returns Response instead of Result(Response, String).
- web_socket.close returns Nil instead of Result(Nil, String). close_with stays
  wrapped because code and reason can still throw.
- response.new(body: String) is replaced by response.from_string(body), and
  response.new() now takes zero args for an empty-body response.
  response.new_with_init is replaced by response.from_string_with_init.
  response.from_json(data, init) is split into response.from_json(data) and
  response.from_json_with_init(data, init).
- web_socket constructors renamed for consistency with the from_<type> pattern.
  `new(url: String)` → `from_url_string(url: String)`; `new_with_protocols(...)`
  → `from_url_string_with_protocols(...)`; `new_url(url: URL)` →
  `from_url(url: URL)`; `new_url_with_protocols(...)` →
  `from_url_with_protocols(...)`.
- request constructors renamed for consistency with the from_<type> pattern.
  `new(input: String)` → `from_url_string(url: String)` and `new_with_init(...)`
  → `from_url_string_with_init(...)`. Adds `request.from_url(url: URL)` and
  `request.from_url_with_init(...)`. URL-taking variants still return Result
  because the Fetch spec's Request constructor rejects URLs with `user:pass@`
  credentials — the URL type permits credentials, so the check survives the type
  swap.
- the `_init` suffix is dropped from response, request, and fetch with-variants.
  `response.from_string_with_init` → `from_string_with`, and the same rename
  applies to `from_bytes`, `from_blob`, `from_buffer`, `from_form_data`,
  `from_params`, `from_stream`, and `from_json`.
  `request.from_url_string_with_init` → `from_url_string_with`, and the same
  applies to `from_url` and `from_request`. `gossamer.fetch_with_init` →
  `fetch_with`, and `gossamer.fetch_url_with_init` → `fetch_url_with`.
- `url_pattern.new_from_string` is renamed to `url_pattern.from_string`, and
  `url_pattern.new_from_string_with_base` is renamed to
  `url_pattern.from_string_with_base`. The init-taking `url_pattern.new(init)`
  constructor is unchanged; it matches the init-list `new(init)` pattern used by
  readable_stream, writable_stream, and transform_stream.
- the `gossamer/error` module is renamed to `gossamer/js_error` and the `Error`
  type is renamed to `JsError`. All helpers keep their names: `js_error.new`,
  `js_error.type_error`, `js_error.message`, `js_error.cause`, etc.
- all `subtle_crypto` operations now return `Promise(Result(_, JsError))`
  instead of `Promise(Result(_, String))`. Callers that pattern-match the error
  branch should read the message via `js_error.message(err)`.
- callers destructuring `Error(msg)` must replace `msg` with
  `js_error.message(err)`, or handle the `JsError` value directly.
- removes `gossamer/dom_exception`. Nothing in the library accepted or returned
  a DOMException — classification is now handled by `js_error.kind(err)`
  returning `kind.DomException(name:)`. The legacy numeric `code` property is
  dropped; modern code uses `name`.
- return / return_with / throw signatures change from Result(IteratorResult,
  Nil) to Result(IteratorHandlerOutcome, JsError). Callers matching on
  Error(Nil) for "no handler" match on Ok(NoHandler) instead.
- all listed functions now return Result(T, JsError) instead of T. Callers
  destructure with `let assert Ok(x) = ...` or handle the Error branch.
- writable_stream.from_write, readable_stream.from_pull, and
  transform_stream.from_transform no longer return Result. Callers doing
  `let assert Ok(stream) = from_write(...)` should drop the outer assertion.
- headers.get returns Result(Option(String), JsError) instead of Result(String,
  JsError). Callers that matched Ok(value) should now match Ok(Some(value));
  callers that relied on Error to mean "missing" should match Ok(None).
- `array_buffer.ArrayBufferView` is removed. `byob_reader.read`'s `view`
  parameter and the inner `ReadResult` value are now `Uint8Array` instead of
  `ArrayBufferView`.
- `array.with` and `uint8_array.with` now return `Result(_, JsError)` instead of
  the unwrapped value. Both throw `RangeError` when the index is out of range;
  callers must destructure with `let assert Ok(x) = ...` or handle the `Error`
  branch.
- `array_buffer.slice` variants are renamed to align with `uint8_array`'s
  range-parameter naming convention. `slice(buffer, from:)` is renamed to
  `slice_from(buffer, start)`, and `slice_with_end(buffer, from:, to:)` is
  renamed to `slice_range(buffer, from:, to:)`. A new zero-arg `slice(buffer)`
  returns a full copy for parity with `uint8_array.slice`.
- `request.cache`, `credentials`, `mode`, `referrer_policy`, and `destination`
  now return their spec defaults when the runtime returns `undefined` (Deno gap,
  denoland/deno#27763) instead of producing `Other(undefined)`.
  `request.referrer`, `integrity`, and `is_keepalive` panic at the FFI on
  `undefined` with a diagnostic naming the runtime and upstream issue.
  `readable_stream.from_iterator` and `from_async_iterator` panic when
  `ReadableStream.from` is missing (Bun gap, oven-sh/bun#3700).

### Features

- unwrap response.new
- unwrap web_socket.close
- add response body type variants
- add URL-typed redirect variants
- add URL-typed fetch variants
- add URL-typed web_socket constructors
- add request body type variants
- rename web_socket constructors to from_<type>
- rename request constructors to from_<type>
- add request.from_request constructors
- add RequestPriority for Fetch priority hints
- add fetch_request_with for request + init overload
- add _with_cause constructors to error module
- add JsErrorKind for classifying JsError
- add IteratorHandlerOutcome for iterator return/throw
- headers.get distinguishes missing from invalid

### Fixes

- wrap previously-missed throwing APIs in Result
- pass reason through to iterator.throw handler
- pass reason through to async_iterator.throw handler
- unwrap stream convenience constructors
- surface undefined priority as Auto instead of Other(Nil)
- drop ArrayBufferView record; narrow byob_reader.read to Uint8Array
- surface Node Timeout numeric id from set_timeout/set_interval
- correct toGleamIteratorResult type parameter order
- update basic example to v8 headers.get shape
- wrap array.with and uint8_array.with in Result
- surface runtime divergence with FFI panics and enum defaults

## 7.0.0 (2026-04-18)

### Breaking Changes

- WebSocket close/close_with return Result(Nil, String) instead of Nil. The
  previous send/send_dynamic functions are replaced by four typed variants —
  send_string, send_bytes, send_blob, send_buffer — all returning Result(Nil,
  String).
- Multiple collection API changes for Gleam ergonomics: keys/values/entries
  return Iterator instead of List on headers, url_search_params, uint8_array,
  map, set, and form_data; map.delete and set.delete return the collection
  instead of Bool, matching stdlib dict.delete; for_each callback arg order
  flipped from JS (value, key) to Gleam (key, value) on map, headers, form_data,
  and url_search_params; index_of, last_index_of, find_index, and
  find_last_index return Result(Int, Nil) instead of -1 on array, uint8_array,
  and string; FormData values/entries/for_each now include File values via a
  FormDataValue type instead of silently filtering them out.
- Import paths change for 19 types — the old satellite modules (close_event,
  event_init, request_init, url_pattern_init, etc.) no longer exist. Import
  their types from the anchor module instead.
- ~62 functions now return Result or Promise(Result(T, String)) — consumers need
  to destructure the Result with `let assert Ok(x) = ...` when confident or
  handle the Error branch explicitly.
- ResponseInit.Status, response.status, and response.redirect_with_status now
  use HttpStatus instead of Int. readable_stream.from is removed — use
  readable_stream.from_iterator or readable_stream.from_async_iterator.

### Features

- wrap WebSocket send/close in Result with typed send variants
- make collections more Gleam-idiomatic
- consolidate satellite types into anchor modules
- wrap throwing Web APIs and rejectable Promises in Result
- add HttpStatus enum and split readable_stream.from

### Fixes

- type Iterator$ and AsyncIterator$ as IterableIterator

## 6.8.0 (2026-04-14)

### Features

- add String module with Unicode, locale, and full JS string API

## 6.7.0 (2026-04-14)

### Features

- add Array module with full spec coverage

## 6.6.0 (2026-04-14)

### Features

- add Symbol module with global registry

## 6.5.0 (2026-04-14)

### Features

- add Map and Set modules with full spec coverage

## 6.4.0 (2026-04-13)

### Features

- add Iterator Helpers (map, filter, take, drop, flat_map, reduce, some, every,
  find)

## 6.3.0 (2026-04-13)

### Features

- complete Iterator, AsyncIterator, and URL modules

## 6.2.0 (2026-04-10)

### Features

- add Math module with constants, trig, log, and utility functions
- add Number module with type checks, formatting, and parsing

## 6.1.0 (2026-04-10)

### Features

- add CustomEvent module, complete Uint8Array and ArrayBuffer APIs

## 6.0.0 (2026-04-10)

### Breaking Changes

- add Date module with full API surface

### Features

- add Event and EventTarget modules

## 5.0.0 (2026-04-09)

### Breaking Changes

- import_key_jwk now takes JsonWebKey instead of Dynamic, and export_key_jwk
  returns JsonWebKey instead of Dynamic.
- request property getters (cache, credentials, destination, mode, redirect,
  referrer_policy), response.type_, and RequestInit Redirect now use variant
  types instead of String.
- DigestAlgorithm replaced by HashAlgorithm. All crypto algorithm String fields
  now use variant types. KeyAlgorithm.Hmac loses its name field.
- request.method returns HttpMethod instead of String. RequestInit.Method takes
  HttpMethod instead of String. Encoding functions return Encoding instead of
  String. response.json renamed to response.from_json, response.json_body
  renamed to response.json. Algorithm type Name(String) variants renamed to
  Other(String).

### Features

- add JsonWebKey type for typed JWK import/export
- add types for request and response properties
- add Other(String) fallback to existing variant types
- add shared crypto variant types for algorithm strings
- add forward compatibility variants to existing types
- add HttpMethod and Encoding types, rename response JSON methods
- add missing RequestInit options

## 4.1.0 (2026-04-09)

### Features

- add labels to function arguments
- widen side-effect callback return types
- use generic types for Dynamic input parameters

## 4.0.1 (2026-04-08)

### Fixes

- widen Uint8Array type to accept ArrayBufferLike

## 4.0.0 (2026-04-08)

### Breaking Changes

- correct types and error handling from audit
- Removes alert, close, confirm, prompt, report_error. Changes return types on
  console, response.json, crypto_key.algorithm, subtle_crypto.digest,
  user_agent, async_iterator return/throw, and reader.read.

### Features

- add URLPattern, DOMException, and Error types modules

### Fixes

- improve type safety, add tests, and remove non-cross-runtime APIs

## 3.4.0 (2026-04-07)

### Features

- add MessageChannel, MessagePort, and queuing strategy modules

## 3.3.0 (2026-04-07)

### Features

- add console, performance, and navigator.userAgent modules

## 3.2.0 (2026-04-07)

### Features

- complete File, add ArrayBuffer/Uint8Array/AbortSignal members

## 3.1.0 (2026-04-07)

### Features

- add formData(), structuredClone, atob, btoa, TextEncoder.encoding

## 3.0.0 (2026-04-07)

### Breaking Changes

- add missing API members, ready state type, abort variants

## 2.0.0 (2026-04-07)

### Breaking Changes

- use Result for unsafe APIs, rename boolean getters, remove non-standard
  properties

## 1.0.1 (2026-04-07)

### Fixes

- use .type.ts files for external type annotations
