# Coverage

gossamer targets cross-runtime JavaScript APIs — both Web Platform and
ECMAScript. This includes APIs with no Gleam equivalent and native JS types that
complement Gleam's standard library for interop. All APIs must work in Deno,
Node.js, Bun, and browsers.

## Specs

- [WinterTC Minimum Common API](https://min-common-api.proposal.wintertc.org/) —
  cross-runtime Web Platform baseline. Includes:
  - [Fetch Standard](https://fetch.spec.whatwg.org/) — fetch, Headers, Request,
    Response
  - [URL Standard](https://url.spec.whatwg.org/) — URL, URLSearchParams
  - [Streams Standard](https://streams.spec.whatwg.org/) — ReadableStream,
    WritableStream, TransformStream
  - [Encoding Standard](https://encoding.spec.whatwg.org/) — TextDecoder,
    TextDecoderStream, TextEncoderStream
  - [Web Crypto API](https://www.w3.org/TR/WebCryptoAPI/) — Crypto,
    SubtleCrypto, CryptoKey
  - [File API](https://www.w3.org/TR/FileAPI/) — Blob, File
  - [Compression Streams](https://compression.spec.whatwg.org/) —
    CompressionStream, DecompressionStream
  - [DOM Standard](https://dom.spec.whatwg.org/) — AbortController, AbortSignal
  - [XMLHttpRequest Standard](https://xhr.spec.whatwg.org/) — FormData
- [WebSocket Standard](https://websockets.spec.whatwg.org/) — WebSocket (outside
  WinterTC minimum)
- [URL Pattern API](https://urlpattern.spec.whatwg.org/) — URLPattern (outside
  WinterTC minimum)
- [HTML Living Standard](https://html.spec.whatwg.org/) — Web Workers,
  MessageChannel, MessagePort (outside WinterTC minimum)
- [ECMAScript (ECMA-262)](https://tc39.es/ecma262/) — JavaScript language
  built-ins
- [ECMAScript Internationalization API (ECMA-402)](https://tc39.es/ecma402/) —
  `Intl.*` formatters and locale-aware operations

## Web Platform APIs

### Fetch & HTTP

| Name     | Module                                                                       |
| -------- | ---------------------------------------------------------------------------- |
| fetch    | [`gossamer/fetch_extra`](./gossamer/fetch_extra.html)                        |
| FormData | [`gossamer/form_data_extra`](./gossamer/form_data_extra.html) (file uploads) |

`Request`, `Response`, and `Headers` come from
[`gleam_http`](https://hexdocs.pm/gleam_http/). The underlying fetch call and
the `FormData` type come from [`gleam_fetch`](https://hexdocs.pm/gleam_fetch/).

[`gossamer/fetch_extra`](./gossamer/fetch_extra.html) adds the Fetch-spec init
dict as a `FetchOptions` builder, plus `send` variants that consume it. Errors
come from
[`gleam/fetch.FetchError`](https://hexdocs.pm/gleam_fetch/gleam/fetch.html#FetchError);
inspect aborts via `gossamer/abort_signal` on the signal you passed to
`set_signal`.

[`gossamer/form_data_extra`](./gossamer/form_data_extra.html) adds `append_file`
/ `set_file` for multipart file uploads.

### URL

| Name       | Module                                                |
| ---------- | ----------------------------------------------------- |
| URL        | [`gossamer/url`](./gossamer/url.html)                 |
| URLPattern | [`gossamer/url_pattern`](./gossamer/url_pattern.html) |

[`gleam/uri.Uri`](https://hexdocs.pm/gleam_stdlib/gleam/uri.html#Uri) is the
canonical Gleam URL type. [`gossamer/url`](./gossamer/url.html) wraps the JS
`URL` constructor for WHATWG-strict parsing into a `gleam/uri.Uri` — useful when
JS and Gleam disagree on whether a string parses. `URLSearchParams` parsing is
delegated to
[`gleam/uri.parse_query`](https://hexdocs.pm/gleam_stdlib/gleam/uri.html#parse_query);
manipulate the resulting `List(#(String, String))` with
[`gleam/list`](https://hexdocs.pm/gleam_stdlib/gleam/list.html).

### WebSocket

| Name      | Module                                              |
| --------- | --------------------------------------------------- |
| WebSocket | [`gossamer/web_socket`](./gossamer/web_socket.html) |

### Workers & Messaging

| Name             | Module                                                            |
| ---------------- | ----------------------------------------------------------------- |
| Worker           | [`gossamer/worker`](./gossamer/worker.html)                       |
| MessageChannel   | [`gossamer/message_channel`](./gossamer/message_channel.html)     |
| MessagePort      | [`gossamer/message_port`](./gossamer/message_port.html)           |
| BroadcastChannel | [`gossamer/broadcast_channel`](./gossamer/broadcast_channel.html) |

Gleam worker scripts use
[`gossamer/worker_parent`](./gossamer/worker_parent.html) for `post_message` and
`set_on_message`; the parent spawns them with
`worker.from_module("my_app/worker")`. The FFI bridges Web Workers on Deno, Bun,
and browsers with Node's `worker_threads` so the same script runs on all three.

[`gossamer/broadcast_channel`](./gossamer/broadcast_channel.html) sends messages
between every channel of the same name in the same agent — same-origin workers,
tabs, and iframes.

### Streams

| Name                             | Module                                                                                                              |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| ReadableStream                   | [`gossamer/stream/readable_stream`](./gossamer/stream/readable_stream.html)                                         |
| ReadableStreamDefaultReader      | [`gossamer/stream/readable_stream/reader`](./gossamer/stream/readable_stream/reader.html)                           |
| ReadableStreamDefaultController  | [`gossamer/stream/readable_stream/default_controller`](./gossamer/stream/readable_stream/default_controller.html)   |
| WritableStream                   | [`gossamer/stream/writable_stream`](./gossamer/stream/writable_stream.html)                                         |
| WritableStreamDefaultWriter      | [`gossamer/stream/writable_stream/writer`](./gossamer/stream/writable_stream/writer.html)                           |
| WritableStreamDefaultController  | [`gossamer/stream/writable_stream/default_controller`](./gossamer/stream/writable_stream/default_controller.html)   |
| TransformStream                  | [`gossamer/stream/transform_stream`](./gossamer/stream/transform_stream.html)                                       |
| TransformStreamDefaultController | [`gossamer/stream/transform_stream/default_controller`](./gossamer/stream/transform_stream/default_controller.html) |

[`gossamer/stream`](./gossamer/stream.html) is the family parent — it hosts
`QueuingStrategy` (collapsing the JS `ByteLengthQueuingStrategy` and
`CountQueuingStrategy` classes into variants) and `StreamLifecycleError`.

### Compression

| Name                | Module                                                                                          |
| ------------------- | ----------------------------------------------------------------------------------------------- |
| CompressionStream   | [`gossamer/compression/compression_stream`](./gossamer/compression/compression_stream.html)     |
| DecompressionStream | [`gossamer/compression/decompression_stream`](./gossamer/compression/decompression_stream.html) |

[`gossamer/compression`](./gossamer/compression.html) hosts the shared
`CompressionFormat`.

### Text Encoding

| Name              | Module                                                                                  |
| ----------------- | --------------------------------------------------------------------------------------- |
| TextDecoder       | [`gossamer/encoding/text_decoder`](./gossamer/encoding/text_decoder.html)               |
| TextEncoderStream | [`gossamer/encoding/text_encoder_stream`](./gossamer/encoding/text_encoder_stream.html) |
| TextDecoderStream | [`gossamer/encoding/text_decoder_stream`](./gossamer/encoding/text_decoder_stream.html) |

[`gossamer/encoding`](./gossamer/encoding.html) hosts the shared `Encoding` and
`DecoderError`.

`TextEncoder` is omitted in favor of
[`gleam/bit_array.from_string`](https://hexdocs.pm/gleam_stdlib/gleam/bit_array.html#from_string)
/ `<<s:utf8>>`. For default UTF-8 decoding, use
[`gleam/bit_array.to_string`](https://hexdocs.pm/gleam_stdlib/gleam/bit_array.html#to_string);
`text_decoder.decode` requires an explicit encoding label.

### Crypto

| Name         | Module                                                    |
| ------------ | --------------------------------------------------------- |
| Crypto       | [`gossamer/crypto`](./gossamer/crypto.html)               |
| SubtleCrypto | [`gossamer/crypto/subtle`](./gossamer/crypto/subtle.html) |
| CryptoKey    | [`gossamer/crypto/key`](./gossamer/crypto/key.html)       |
| JsonWebKey   | [`gossamer/crypto/jwk`](./gossamer/crypto/jwk.html)       |

[`gossamer/crypto`](./gossamer/crypto.html) exposes `random_uuid` and hosts the
types shared across the submodules — `KeyUsage`, `CryptoError`, `KeyKind`, and
the algorithm types (`AesAlgorithm`, `RsaAlgorithm`, `EcAlgorithm`,
`HashAlgorithm`, `NamedCurve`, `KeyAlgorithm`).

For simple primitives (hashing, HMAC, random bytes, secure compare, message
signing), prefer [`gleam_crypto`](https://hexdocs.pm/gleam_crypto/) — it's sync
and skips the key-import ceremony Web Crypto requires. Reach for
[`gossamer/crypto`](./gossamer/crypto.html) for the full Web Crypto API (key
generation, AES / RSA encryption, JSON Web Keys, key derivation).

### Data Types

| Name | Module                                  |
| ---- | --------------------------------------- |
| Blob | [`gossamer/blob`](./gossamer/blob.html) |
| File | [`gossamer/file`](./gossamer/file.html) |

### Cancellation

| Name            | Module                                                          |
| --------------- | --------------------------------------------------------------- |
| AbortController | [`gossamer/abort_controller`](./gossamer/abort_controller.html) |
| AbortSignal     | [`gossamer/abort_signal`](./gossamer/abort_signal.html)         |

### Globals

| Name                                                   | Module                                                                  |
| ------------------------------------------------------ | ----------------------------------------------------------------------- |
| atob (`decode_base64`)                                 | `gossamer`                                                              |
| btoa (`encode_base64`)                                 | `gossamer`                                                              |
| setTimeout / clearTimeout                              | `gossamer`                                                              |
| setInterval / clearInterval                            | `gossamer`                                                              |
| queueMicrotask                                         | `gossamer`                                                              |
| navigator.userAgent (`user_agent`)                     | `gossamer`                                                              |
| navigator.hardwareConcurrency (`hardware_concurrency`) | `gossamer`                                                              |
| console                                                | [`gossamer/console`](./gossamer/console.html)                           |
| Performance                                            | [`gossamer/performance`](./gossamer/performance.html)                   |
| PerformanceEntry                                       | [`gossamer/performance_entry`](./gossamer/performance_entry.html)       |
| PerformanceObserver                                    | [`gossamer/performance_observer`](./gossamer/performance_observer.html) |

`reportError` is not bound — runtime support is uneven and Gleam consumers have
no idiomatic use; log via `console.error` instead.

## ECMAScript Built-ins

### Native (no Gleam stdlib equivalent)

| Name   | Module                                        |
| ------ | --------------------------------------------- |
| BigInt | [`gossamer/big_int`](./gossamer/big_int.html) |

`BigInt` is the only ECMAScript built-in gossamer binds that has no Gleam
canonical — Gleam's `Int` is fixed-width, so arbitrary-precision integers need a
dedicated type.

### Extending Gleam stdlib

These bindings layer on top of an existing Gleam-canonical type — as transit
types (the JS native form, exposed for interop while the canonical Gleam type
stays preferred), as `*_extra` modules (gap-filling capabilities the Gleam
canonical doesn't cover), or — in `gossamer/json`'s case — as a transparent
Gleam type that mirrors a JS namespace.

| Name          | Module                                                                                                   |
| ------------- | -------------------------------------------------------------------------------------------------------- |
| ArrayBuffer   | [`gossamer/array_buffer`](./gossamer/array_buffer.html)                                                  |
| Uint8Array    | [`gossamer/uint8_array`](./gossamer/uint8_array.html)                                                    |
| Iterator      | [`gossamer/iteration/iterator`](./gossamer/iteration/iterator.html)                                      |
| AsyncIterator | [`gossamer/iteration/async_iterator`](./gossamer/iteration/async_iterator.html)                          |
| Map           | [`gossamer/map`](./gossamer/map.html)                                                                    |
| Set           | [`gossamer/set`](./gossamer/set.html)                                                                    |
| String        | [`gossamer/string_extra`](./gossamer/string_extra.html)                                                  |
| Number / Math | [`gossamer/int_extra`](./gossamer/int_extra.html), [`gossamer/float_extra`](./gossamer/float_extra.html) |
| Date          | [`gossamer/time_extra`](./gossamer/time_extra.html)                                                      |
| RegExp        | [`gossamer/regexp_extra`](./gossamer/regexp_extra.html)                                                  |
| Symbol        | [`gossamer/symbol_extra`](./gossamer/symbol_extra.html)                                                  |
| JSON          | [`gossamer/json`](./gossamer/json.html)                                                                  |

**Transit types** are JS native types exposed for interop with JS APIs that
return them while the canonical Gleam type stays preferred. `ArrayBuffer` /
`Uint8Array` bridge to `BitArray`; `Iterator` bridges to
[`gleam_yielder.Yielder`](https://hexdocs.pm/gleam_yielder/); `Map` / `Set`
bridge to [`gleam/dict`](https://hexdocs.pm/gleam_stdlib/gleam/dict.html) /
[`gleam/set`](https://hexdocs.pm/gleam_stdlib/gleam/set.html). `AsyncIterator`
has no canonical Gleam counterpart — consume it via the binding's own helpers.
[`gossamer/iteration`](./gossamer/iteration.html) hosts the shared
`IteratorResult` type used by both `iterator` and `async_iterator`.

**Extras** modules layer JS-specific capabilities on top of Gleam's canonical
types ([`gleam/string`](https://hexdocs.pm/gleam_stdlib/gleam/string.html),
[`gleam/int`](https://hexdocs.pm/gleam_stdlib/gleam/int.html),
[`gleam/float`](https://hexdocs.pm/gleam_stdlib/gleam/float.html),
[`gleam/time`](https://hexdocs.pm/gleam_time/),
[`gleam/regexp`](https://hexdocs.pm/gleam_regexp/),
[`gleam/javascript/symbol`](https://hexdocs.pm/gleam_javascript/gleam/javascript/symbol.html)),
which already are the JS primitives under the hood. `Number` and `Math` split
across `int_extra` and `float_extra` mirroring `gleam/int` / `gleam/float`.

[`gossamer/json`](./gossamer/json.html) provides a transparent `Json` type for
inspecting or pattern-matching JSON of unknown structure. For typed
encode/decode pipelines, use [`gleam_json`](https://hexdocs.pm/gleam_json/).

### Internationalization (ECMA-402)

| Name                    | Module                                                                            |
| ----------------------- | --------------------------------------------------------------------------------- |
| Intl.Collator           | [`gossamer/intl/collator`](./gossamer/intl/collator.html)                         |
| Intl.DateTimeFormat     | [`gossamer/intl/date_time_format`](./gossamer/intl/date_time_format.html)         |
| Intl.DisplayNames       | [`gossamer/intl/display_names`](./gossamer/intl/display_names.html)               |
| Intl.DurationFormat     | [`gossamer/intl/duration_format`](./gossamer/intl/duration_format.html)           |
| Intl.ListFormat         | [`gossamer/intl/list_format`](./gossamer/intl/list_format.html)                   |
| Intl.Locale             | [`gossamer/intl/locale`](./gossamer/intl/locale.html)                             |
| Intl.NumberFormat       | [`gossamer/intl/number_format`](./gossamer/intl/number_format.html)               |
| Intl.PluralRules        | [`gossamer/intl/plural_rules`](./gossamer/intl/plural_rules.html)                 |
| Intl.RelativeTimeFormat | [`gossamer/intl/relative_time_format`](./gossamer/intl/relative_time_format.html) |
| Intl.Segmenter          | [`gossamer/intl/segmenter`](./gossamer/intl/segmenter.html)                       |

[`gossamer/intl`](./gossamer/intl.html) hosts shared enums (`LabelStyle`,
`LocaleMatcher`, `RangePartSource`, `HourCycle`, `CaseFirst`,
`SupportedValueKey`) used across the formatter submodules, plus the top-level
helpers `get_canonical_locales` (BCP 47 tag canonicalization) and
`supported_values_of` (enumerate runtime-supported calendars, currencies, time
zones, etc.).

### Delegated

| Name    | Module                                                                                          |
| ------- | ----------------------------------------------------------------------------------------------- |
| Promise | [`gleam/javascript/promise`](https://hexdocs.pm/gleam_javascript/gleam/javascript/promise.html) |
| Array   | [`gleam/javascript/array`](https://hexdocs.pm/gleam_javascript/gleam/javascript/array.html)     |

Use the upstream bindings directly — gossamer doesn't wrap them.

## Out of Scope

| Category                                                           | Reason                                                                                                        |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| DOM APIs (document, window, Element, etc.)                         | Browser-only                                                                                                  |
| Event, EventTarget, CustomEvent                                    | Use a typed Gleam dispatcher; FFI for interop with JS-library targets                                         |
| ErrorEvent, `on_error` / `on_message_error` handlers               | Gleam code uses `Result` instead of throwing; event handlers for JS throws don't fit                          |
| MessageEvent                                                       | Receive handlers expose the payload directly; the event's metadata (origin, ports, source) doesn't apply here |
| PromiseRejectionEvent                                              | Not exposed as a global on Node or Bun                                                                        |
| structuredClone                                                    | Gleam values are immutable; the "break shared references" primitive doesn't translate                         |
| WebAssembly                                                        | Warrants its own package                                                                                      |
| Proxy, Reflect                                                     | Metaprogramming, not expressible in Gleam's type system                                                       |
| SharedArrayBuffer, Atomics                                         | Cross-thread shared memory; revisit when a concrete cross-runtime use case arrives                            |
| Generator, AsyncGenerator                                          | Iterator creation via protocol is sufficient                                                                  |
| ServiceWorker, SharedWorker                                        | Browser-only with no cross-runtime equivalent                                                                 |
| WeakMap, WeakSet, WeakRef, FinalizationRegistry                    | Revisit when a concrete use case arrives                                                                      |
| Typed arrays beyond `Uint8Array` (`Int8Array`/`Float64Array`/etc.) | `Uint8Array` covers byte data via the `BitArray` bridge                                                       |
| DataView                                                           | Bridge via `Uint8Array` for raw bytes                                                                         |
| ReadableStreamBYOBReader, ReadableByteStreamController             | Default reader and controller cover the cross-runtime use cases                                               |

Several of these unbound APIs exist for JS-specific performance or memory
characteristics — `WeakMap` / `WeakSet` / `WeakRef` / `FinalizationRegistry` let
the GC collect referenced objects when nothing else holds them; typed arrays
beyond `Uint8Array` expose typed views (`Float64Array`, `Int32Array`) for
numeric data without boxing; `DataView` gives structured byte-level access for
binary protocols; `ReadableStreamBYOBReader` reuses buffers to avoid copies.
Gossamer prefers the simpler Gleam-canonical types (`BitArray`, `gleam/dict`,
`gleam/set`) until concrete cross-runtime needs surface. Reach into FFI directly
when you specifically need one of these characteristics.
