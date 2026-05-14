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
- [ECMAScript (ECMA-262)](https://tc39.es/ecma262/) — JavaScript language
  built-ins

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
dict as a `FetchOptions` builder. Its `FetchError` supersedes `gleam_fetch`'s
`FetchError` to add `Aborted` for `AbortSignal`-cancelled sends.

[`gossamer/form_data_extra`](./gossamer/form_data_extra.html) adds `append_file`
/ `set_file` for multipart file uploads.

### URL

| Name       | Module                                                |
| ---------- | ----------------------------------------------------- |
| URL        | [`gossamer/url`](./gossamer/url.html)                 |
| URLPattern | [`gossamer/url_pattern`](./gossamer/url_pattern.html) |

[`gleam/uri`](https://hexdocs.pm/gleam_stdlib/gleam/uri.html) is the canonical
Gleam URL type. [`gossamer/url`](./gossamer/url.html) wraps the JS `URL`
constructor for WHATWG-strict parsing into a `gleam/uri.Uri` — useful when JS
and Gleam disagree on whether a string parses. `URLSearchParams` is delegated
entirely to `gleam/uri.parse_query`.

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
`CompressionFormat` enum.

### Text Encoding

| Name              | Module                                                                                  |
| ----------------- | --------------------------------------------------------------------------------------- |
| TextDecoder       | [`gossamer/encoding/text_decoder`](./gossamer/encoding/text_decoder.html)               |
| TextEncoderStream | [`gossamer/encoding/text_encoder_stream`](./gossamer/encoding/text_encoder_stream.html) |
| TextDecoderStream | [`gossamer/encoding/text_decoder_stream`](./gossamer/encoding/text_decoder_stream.html) |

[`gossamer/encoding`](./gossamer/encoding.html) hosts the shared `Encoding` enum
and `DecoderError`.

`TextEncoder` is omitted in favor of `gleam/bit_array.from_string` /
`<<s:utf8>>`. For default UTF-8 decoding, use `gleam/bit_array.to_string`;
`text_decoder.decode` requires an explicit encoding label.

### Crypto

| Name         | Module                                                    |
| ------------ | --------------------------------------------------------- |
| Crypto       | [`gossamer/crypto`](./gossamer/crypto.html)               |
| SubtleCrypto | [`gossamer/crypto/subtle`](./gossamer/crypto/subtle.html) |
| CryptoKey    | [`gossamer/crypto/key`](./gossamer/crypto/key.html)       |
| JsonWebKey   | [`gossamer/crypto/jwk`](./gossamer/crypto/jwk.html)       |

[`gossamer/crypto`](./gossamer/crypto.html) is both the `Crypto` interface
(`random_uuid`) and the family parent for the submodules. It hosts the shared
`KeyUsage`, `CryptoError`, `KeyKind`, and the algorithm enums (`AesAlgorithm`,
`RsaAlgorithm`, `EcAlgorithm`, `HashAlgorithm`, `NamedCurve`, `KeyAlgorithm`).

For simple primitives (hashing, HMAC, CSPRNG, secure compare, message signing),
prefer [`gleam_crypto`](https://hexdocs.pm/gleam_crypto/) — it's sync and skips
the key-import ceremony Web Crypto requires. Reach for
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

### Timers & Scheduling

| Name           | Module     |
| -------------- | ---------- |
| setTimeout     | `gossamer` |
| setInterval    | `gossamer` |
| clearTimeout   | `gossamer` |
| clearInterval  | `gossamer` |
| queueMicrotask | `gossamer` |

### Utilities

| Name                   | Module                                                            |
| ---------------------- | ----------------------------------------------------------------- |
| structuredClone        | `gossamer`                                                        |
| atob (`decode_base64`) | `gossamer`                                                        |
| btoa (`encode_base64`) | `gossamer`                                                        |
| console                | [`gossamer/console`](./gossamer/console.html)                     |
| Performance            | [`gossamer/performance`](./gossamer/performance.html)             |
| PerformanceEntry       | [`gossamer/performance_entry`](./gossamer/performance_entry.html) |
| navigator.userAgent    | `gossamer`                                                        |

`reportError` is not bound — runtime support is uneven and Gleam consumers have
no idiomatic use; log via `console.error` instead.

### WebSocket

| Name      | Module                                              |
| --------- | --------------------------------------------------- |
| WebSocket | [`gossamer/web_socket`](./gossamer/web_socket.html) |

## ECMAScript Built-ins

### Native (no Gleam stdlib equivalent)

| Name   | Module                                        |
| ------ | --------------------------------------------- |
| BigInt | [`gossamer/big_int`](./gossamer/big_int.html) |

`BigInt` is the only ECMAScript built-in gossamer binds that has no Gleam
canonical — Gleam's `Int` is fixed-width, so arbitrary-precision integers need a
dedicated type.

### Extending Gleam stdlib

These bindings layer on top of an existing Gleam-canonical type — either as
transit types (the JS native form, exposed for interop while the canonical Gleam
type stays preferred) or as `*_extra` modules (gap-filling capabilities the
Gleam canonical doesn't cover).

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
bridge to `gleam/dict` / `gleam/set`. `AsyncIterator` has no canonical Gleam
counterpart — consume it via the binding's own helpers.
[`gossamer/iteration`](./gossamer/iteration.html) hosts the shared
`IteratorResult` type used by both iterators.

**Extras** modules layer JS-specific capabilities on top of Gleam's canonical
types (`gleam/string`, `gleam/int`, `gleam/float`, `gleam/time`, `gleam/regexp`,
`gleam/javascript/symbol`), which already are the JS primitives under the hood.
`Number` and `Math` split across `int_extra` and `float_extra` mirroring
`gleam/int` / `gleam/float`.

[`gossamer/json`](./gossamer/json.html) provides a transparent `Json` type for
inspecting or pattern-matching JSON of unknown structure. For typed
encode/decode pipelines, use [`gleam_json`](https://hexdocs.pm/gleam_json/).

### Delegated

| Name    | Module                                                                                          |
| ------- | ----------------------------------------------------------------------------------------------- |
| Promise | [`gleam/javascript/promise`](https://hexdocs.pm/gleam_javascript/gleam/javascript/promise.html) |
| Array   | [`gleam/javascript/array`](https://hexdocs.pm/gleam_javascript/gleam/javascript/array.html)     |

Use the upstream bindings directly — gossamer doesn't wrap them.

## Out of Scope

| Category                                                           | Reason                                                                |
| ------------------------------------------------------------------ | --------------------------------------------------------------------- |
| DOM APIs (document, window, Element, etc.)                         | Browser-only                                                          |
| Event, EventTarget, CustomEvent                                    | Use a typed Gleam dispatcher; FFI for interop with JS-library targets |
| ErrorEvent                                                         | Re-add receive-only when Worker support arrives                       |
| PromiseRejectionEvent                                              | Not exposed as a global on Node or Bun                                |
| WebAssembly                                                        | Warrants its own package                                              |
| Proxy, Reflect                                                     | Metaprogramming, not expressible in Gleam's type system               |
| SharedArrayBuffer, Atomics                                         | Threading; revisit if Workers become cross-runtime                    |
| Generator, AsyncGenerator                                          | Iterator creation via protocol is sufficient                          |
| Worker, ServiceWorker, SharedWorker, MessageChannel, MessagePort   | Deferred until cross-realm messaging is well-supported                |
| Intl (`DateTimeFormat`, `NumberFormat`, `Collator`, etc.)          | Deferred; revisit with one builder module per constructor             |
| WeakMap, WeakSet, WeakRef, FinalizationRegistry                    | Not yet bound; revisit when a concrete use case arrives               |
| Typed arrays beyond `Uint8Array` (`Int8Array`/`Float64Array`/etc.) | Not yet bound; `Uint8Array` covers byte data via `BitArray` bridge    |
| DataView                                                           | Not yet bound; bridge via `Uint8Array` for raw bytes                  |
| ReadableStreamBYOBReader, ReadableByteStreamController             | Default reader and controller cover the cross-runtime use cases       |
