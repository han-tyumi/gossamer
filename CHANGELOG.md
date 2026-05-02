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
