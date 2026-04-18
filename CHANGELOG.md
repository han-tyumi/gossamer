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
