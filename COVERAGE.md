# Coverage

gossamer targets cross-runtime JavaScript APIs — both Web Platform and
ECMAScript. This includes APIs with no Gleam equivalent and native JS types that
complement Gleam's standard library for interop. All APIs must work in Deno,
Node.js, Bun, and browsers.

## Specs

- [WinterTC Minimum Common API](https://min-common-api.proposal.wintertc.org/) —
  cross-runtime Web Platform baseline
- [ECMAScript (ECMA-262)](https://tc39.es/ecma262/) — JavaScript language
  built-ins
- [Fetch Standard](https://fetch.spec.whatwg.org/) — fetch, Headers, Request,
  Response
- [URL Standard](https://url.spec.whatwg.org/) — URL, URLSearchParams
- [Streams Standard](https://streams.spec.whatwg.org/) — ReadableStream,
  WritableStream, TransformStream
- [Encoding Standard](https://encoding.spec.whatwg.org/) — TextDecoder,
  TextDecoderStream, TextEncoderStream
- [Web Crypto API](https://www.w3.org/TR/WebCryptoAPI/) — Crypto, SubtleCrypto,
  CryptoKey
- [File API](https://www.w3.org/TR/FileAPI/) — Blob, File
- [Compression Streams](https://compression.spec.whatwg.org/) —
  CompressionStream, DecompressionStream
- [WebSocket Standard](https://websockets.spec.whatwg.org/) — WebSocket
- [DOM Standard](https://dom.spec.whatwg.org/) — AbortController, AbortSignal
- [XMLHttpRequest Standard](https://xhr.spec.whatwg.org/) — FormData
- [URL Pattern API](https://urlpattern.spec.whatwg.org/) — URLPattern

## Legend

- ✅ Bound
- ❌ Out of scope or unbound

## Web Platform APIs (WinterTC Minimum Common)

### Fetch & HTTP

| Name     | Status | Module                                    |
| -------- | ------ | ----------------------------------------- |
| fetch    | ✅     | `gossamer/fetch_extra`                    |
| FormData | ✅     | `gossamer/form_data_extra` (file uploads) |

`Headers`, `Request`, and `Response` are delegated to `gleam_http`. The
outgoing-request body and Fetch-spec init dict (cache, credentials, integrity,
keepalive, mode, priority, redirect, referrer, referrer policy, signal) live on
`gossamer/fetch_extra` as the `FetchOptions` builder, alongside the `FetchError`
sum that supersedes `gleam_fetch.FetchError` to add `Aborted` for
`AbortSignal`-cancelled sends. String and `BitArray` entries on a `FormData` use
`gleam/fetch/form_data`; `gossamer/form_data_extra` adds `append_file` /
`set_file` for multipart file uploads.

### URL

| Name       | Status | Module                 |
| ---------- | ------ | ---------------------- |
| URL        | ✅     | `gossamer/url`         |
| URLPattern | ✅     | `gossamer/url_pattern` |

`gossamer/url` is slimmed to `parse` + `is_valid` (WHATWG-strict; returns
`gleam/uri.Uri`). `URLSearchParams` is delegated to `gleam/uri.parse_query`
(returns `List(#(String, String))`).

### Streams

| Name                             | Status | Module                                                |
| -------------------------------- | ------ | ----------------------------------------------------- |
| ReadableStream                   | ✅     | `gossamer/stream/readable_stream`                     |
| ReadableStreamDefaultReader      | ✅     | `gossamer/stream/readable_stream/reader`              |
| ReadableStreamDefaultController  | ✅     | `gossamer/stream/readable_stream/default_controller`  |
| WritableStream                   | ✅     | `gossamer/stream/writable_stream`                     |
| WritableStreamDefaultWriter      | ✅     | `gossamer/stream/writable_stream/writer`              |
| WritableStreamDefaultController  | ✅     | `gossamer/stream/writable_stream/default_controller`  |
| TransformStream                  | ✅     | `gossamer/stream/transform_stream`                    |
| TransformStreamDefaultController | ✅     | `gossamer/stream/transform_stream/default_controller` |

`gossamer/stream` is the family parent — it hosts the shared `QueuingStrategy`
(collapsing the JS `ByteLengthQueuingStrategy` and `CountQueuingStrategy`
classes into variants) and the `StreamLifecycleError` sum. BYOB streams
(`ReadableStreamBYOBReader`, `ReadableByteStreamController`) are not bound; the
default reader and controller are sufficient for the cross-runtime use cases
gossamer targets.

### Compression

| Name                | Status | Module                                      |
| ------------------- | ------ | ------------------------------------------- |
| CompressionStream   | ✅     | `gossamer/compression/compression_stream`   |
| DecompressionStream | ✅     | `gossamer/compression/decompression_stream` |

`gossamer/compression` hosts the shared `CompressionFormat` enum.

### Text Encoding

| Name              | Status | Module                                  |
| ----------------- | ------ | --------------------------------------- |
| TextDecoder       | ✅     | `gossamer/encoding/text_decoder`        |
| TextEncoderStream | ✅     | `gossamer/encoding/text_encoder_stream` |
| TextDecoderStream | ✅     | `gossamer/encoding/text_decoder_stream` |

`gossamer/encoding` hosts the shared `Encoding` enum and `DecoderError`.
`TextEncoder` is omitted in favor of `gleam/bit_array.from_string` /
`<<s:utf8>>`. For default UTF-8 decoding, use `gleam/bit_array.to_string`;
`text_decoder.decode` requires an explicit encoding label.

### Crypto

| Name         | Status | Module                   |
| ------------ | ------ | ------------------------ |
| Crypto       | ✅     | `gossamer/crypto`        |
| SubtleCrypto | ✅     | `gossamer/crypto/subtle` |
| CryptoKey    | ✅     | `gossamer/crypto/key`    |
| JsonWebKey   | ✅     | `gossamer/crypto/jwk`    |

`gossamer/crypto` is both the `Crypto` interface (`random_bytes`, `random_uuid`)
and the family parent for the submodules. It hosts the shared `KeyUsage` and
`CryptoError` sums, the algorithm enums (`AesAlgorithm`, `RsaAlgorithm`,
`EcAlgorithm`, `HashAlgorithm`, `NamedCurve`, `KeyAlgorithm`), and the `KeyKind`
classifier (symmetric vs asymmetric public/private).

### Data Types

| Name | Status | Module          |
| ---- | ------ | --------------- |
| Blob | ✅     | `gossamer/blob` |
| File | ✅     | `gossamer/file` |

### Events & DOM

| Name                  | Status | Module | Notes                                                                                |
| --------------------- | ------ | ------ | ------------------------------------------------------------------------------------ |
| Event                 | ❌     | —      | Out of scope. Use a typed Gleam dispatcher; FFI for interop with JS-library targets. |
| EventTarget           | ❌     | —      | Out of scope. See Event.                                                             |
| CustomEvent           | ❌     | —      | Out of scope. See Event.                                                             |
| ErrorEvent            | ❌     | —      | Out of scope. Re-add receive-only when Worker support arrives.                       |
| PromiseRejectionEvent | ❌     | —      | Not exposed as a global on Node or Bun.                                              |

### Cancellation

| Name            | Status | Module                      |
| --------------- | ------ | --------------------------- |
| AbortController | ✅     | `gossamer/abort_controller` |
| AbortSignal     | ✅     | `gossamer/abort_signal`     |

### Timers & Scheduling

| Name           | Status | Module     |
| -------------- | ------ | ---------- |
| setTimeout     | ✅     | `gossamer` |
| setInterval    | ✅     | `gossamer` |
| clearTimeout   | ✅     | `gossamer` |
| clearInterval  | ✅     | `gossamer` |
| queueMicrotask | ✅     | `gossamer` |

### Utilities

| Name                | Status | Module                       |
| ------------------- | ------ | ---------------------------- |
| structuredClone     | ✅     | `gossamer`                   |
| atob / btoa         | ✅     | `gossamer`                   |
| console             | ✅     | `gossamer/console`           |
| Performance         | ✅     | `gossamer/performance`       |
| PerformanceEntry    | ✅     | `gossamer/performance_entry` |
| navigator.userAgent | ✅     | `gossamer`                   |

`reportError` is not bound — runtime support is uneven and Gleam consumers have
no idiomatic use; rethrow or log via `console.error` instead.

## Cross-Runtime Web APIs (beyond WinterTC minimum)

| Name      | Status | Module                |
| --------- | ------ | --------------------- |
| WebSocket | ✅     | `gossamer/web_socket` |

## ECMAScript Built-ins (no Gleam equivalent)

| Name          | Status | Module                              |
| ------------- | ------ | ----------------------------------- |
| ArrayBuffer   | ✅     | `gossamer/array_buffer`             |
| Uint8Array    | ✅     | `gossamer/uint8_array`              |
| Iterator      | ✅     | `gossamer/iteration/iterator`       |
| AsyncIterator | ✅     | `gossamer/iteration/async_iterator` |
| JSON          | ✅     | `gossamer/json`                     |
| RegExp        | ✅     | `gossamer/regexp_extra`             |
| Symbol        | ✅     | `gossamer/symbol_extra`             |
| BigInt        | ✅     | `gossamer/big_int`                  |

`gossamer/iteration` hosts the shared `IteratorResult` type. `Promise` is
delegated to `gleam/javascript/promise`. Gossamer's auto-Result-wrap discipline
at the FFI boundary means user-facing promises don't reject in normal
Gleam-controlled flow, so the rejection-aware extras (`Promise.allSettled`,
`Promise.any`, `Promise.withResolvers`) reduce to upstream's `await_list` /
`race_list` / `start`. JS error types are not exposed as a typed sum —
per-binding typed errors (e.g., `FetchError`, `CryptoError`,
`StreamLifecycleError`) cover the cases users need to react to.

## ECMAScript Built-ins (complements Gleam equivalents)

Gleam has conceptual equivalents for these, but they are not the native JS
types. These bindings enable interop with JS APIs that return or accept native
types, and expose functionality Gleam's stdlib doesn't cover.

| Name          | Status | Module                                       |
| ------------- | ------ | -------------------------------------------- |
| Map           | ✅     | `gossamer/map`                               |
| Set           | ✅     | `gossamer/set`                               |
| String        | ✅     | `gossamer/string_extra`                      |
| Number / Math | ✅     | `gossamer/int_extra`, `gossamer/float_extra` |
| Date          | ✅     | `gossamer/time_extra`                        |

`Map` and `Set` are transit types — exposed for interop with JS APIs that return
them, but `gleam/dict` and `gleam/set` are the canonical Gleam types for
everyday use. `Array` is delegated to `gleam/javascript/array`, which exposes it
as a transit type for JS interop. For collection operations beyond `array.size`
/ `map` / `fold` / `get`, convert to `List` via `array.to_list` and use
`gleam/list`.

`Number` and `Math` split across two modules mirroring Gleam's stdlib —
`int_extra` for integer-relevant members (`max_safe_integer`, `clz32`, `imul`,
locale formatting) and `float_extra` for float-relevant members (`epsilon`,
`min_value` / `max_value`, `pi` / `e`, trig, `log` / `exp` / `pow`).

## Out of Scope

| Category                                   | Reason                                                  |
| ------------------------------------------ | ------------------------------------------------------- |
| DOM APIs (document, window, Element, etc.) | Browser-only                                            |
| WebAssembly                                | Warrants its own package                                |
| Proxy, Reflect                             | Metaprogramming, not expressible in Gleam's type system |
| SharedArrayBuffer, Atomics                 | Threading; revisit if Workers become cross-runtime      |
| Generator, AsyncGenerator                  | Iterator creation via protocol is sufficient            |
