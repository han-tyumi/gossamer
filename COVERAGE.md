# Coverage

gossamer targets cross-runtime JavaScript APIs — both
[Web Platform](https://min-common-api.proposal.wintertc.org/) and
[ECMAScript](https://tc39.es/ecma262/). This includes APIs with no Gleam
equivalent and native JS types that complement Gleam's standard library for
interop. All APIs must work in Deno, Node.js, Bun, and browsers.

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
- [Encoding Standard](https://encoding.spec.whatwg.org/) — TextEncoder,
  TextDecoder
- [Web Crypto API](https://www.w3.org/TR/WebCryptoAPI/) — Crypto, SubtleCrypto,
  CryptoKey
- [File API](https://www.w3.org/TR/FileAPI/) — Blob, File
- [Compression Streams](https://compression.spec.whatwg.org/) —
  CompressionStream, DecompressionStream
- [WebSocket Standard](https://websockets.spec.whatwg.org/) — WebSocket
- [DOM Standard](https://dom.spec.whatwg.org/) — Event, EventTarget,
  AbortController, AbortSignal
- [XMLHttpRequest Standard](https://xhr.spec.whatwg.org/) — FormData
- [URL Pattern API](https://urlpattern.spec.whatwg.org/) — URLPattern

## Legend

- ✅ All spec members bound
- 🚧 Module exists, some members missing
- ❌ No module yet

## Web Platform APIs (WinterTC Minimum Common)

### Fetch & HTTP

| Interface | Status | Module               |
| --------- | ------ | -------------------- |
| fetch()   | ✅     | `gossamer`           |
| Headers   | ✅     | `gossamer/headers`   |
| Request   | ✅     | `gossamer/request`   |
| Response  | ✅     | `gossamer/response`  |
| FormData  | ✅     | `gossamer/form_data` |

### URL

| Interface       | Status | Module                       |
| --------------- | ------ | ---------------------------- |
| URL             | ✅     | `gossamer/url`               |
| URLSearchParams | ✅     | `gossamer/url_search_params` |
| URLPattern      | ✅     | `gossamer/url_pattern`       |

### Streams

| Interface                        | Status | Module                                         |
| -------------------------------- | ------ | ---------------------------------------------- |
| ReadableStream                   | ✅     | `gossamer/readable_stream`                     |
| ReadableStreamDefaultReader      | ✅     | `gossamer/readable_stream/reader`              |
| ReadableStreamBYOBReader         | ✅     | `gossamer/readable_stream/byob_reader`         |
| ReadableStreamDefaultController  | ✅     | `gossamer/readable_stream/default_controller`  |
| WritableStream                   | ✅     | `gossamer/writable_stream`                     |
| WritableStreamDefaultWriter      | ✅     | `gossamer/writable_stream/writer`              |
| WritableStreamDefaultController  | ✅     | `gossamer/writable_stream/default_controller`  |
| TransformStream                  | ✅     | `gossamer/transform_stream`                    |
| TransformStreamDefaultController | ✅     | `gossamer/transform_stream/default_controller` |
| ByteLengthQueuingStrategy        | ✅     | `gossamer/byte_length_queuing_strategy`        |
| CountQueuingStrategy             | ✅     | `gossamer/count_queuing_strategy`              |

### Compression

| Interface           | Status | Module                          |
| ------------------- | ------ | ------------------------------- |
| CompressionStream   | ✅     | `gossamer/compression_stream`   |
| DecompressionStream | ✅     | `gossamer/decompression_stream` |

### Text Encoding

| Interface         | Status | Module                         |
| ----------------- | ------ | ------------------------------ |
| TextEncoder       | ✅     | `gossamer/text_encoder`        |
| TextDecoder       | ✅     | `gossamer/text_decoder`        |
| TextEncoderStream | ✅     | `gossamer/text_encoder_stream` |
| TextDecoderStream | ✅     | `gossamer/text_decoder_stream` |

### Crypto

| Interface    | Status | Module                   |
| ------------ | ------ | ------------------------ |
| Crypto       | ✅     | `gossamer/crypto`        |
| SubtleCrypto | ✅     | `gossamer/subtle_crypto` |
| CryptoKey    | ✅     | `gossamer/crypto_key`    |

### Data Types

| Interface | Status | Module          |
| --------- | ------ | --------------- |
| Blob      | ✅     | `gossamer/blob` |
| File      | ✅     | `gossamer/file` |

### Events & DOM

| Interface             | Status | Module                  | Notes                                  |
| --------------------- | ------ | ----------------------- | -------------------------------------- |
| Event                 | ✅     | `gossamer/event`        |                                        |
| EventTarget           | ✅     | `gossamer/event_target` |                                        |
| CustomEvent           | ✅     | `gossamer/custom_event` |                                        |
| ErrorEvent            | ✅     | `gossamer/error_event`  |                                        |
| PromiseRejectionEvent | ❌     | —                       | Not exposed as a global on Node or Bun |

### Cancellation

| Interface       | Status | Module                      |
| --------------- | ------ | --------------------------- |
| AbortController | ✅     | `gossamer/abort_controller` |
| AbortSignal     | ✅     | `gossamer/abort_signal`     |

### Messaging

| Interface      | Status | Module                     |
| -------------- | ------ | -------------------------- |
| MessageChannel | ✅     | `gossamer/message_channel` |
| MessagePort    | ✅     | `gossamer/message_port`    |
| MessageEvent   | ✅     | `gossamer/message_event`   |

### Timers & Scheduling

| Interface      | Status | Module     |
| -------------- | ------ | ---------- |
| setTimeout     | ✅     | `gossamer` |
| setInterval    | ✅     | `gossamer` |
| clearTimeout   | ✅     | `gossamer` |
| clearInterval  | ✅     | `gossamer` |
| queueMicrotask | ✅     | `gossamer` |

### Utilities

| Interface           | Status | Module                 |
| ------------------- | ------ | ---------------------- |
| structuredClone     | ✅     | `gossamer`             |
| atob / btoa         | ✅     | `gossamer`             |
| reportError         | ✅     | `gossamer`             |
| console             | ✅     | `gossamer/console`     |
| Performance         | ✅     | `gossamer/performance` |
| navigator.userAgent | ✅     | `gossamer`             |

## Cross-Runtime Web APIs (beyond WinterTC minimum)

| Interface | Status | Module                |
| --------- | ------ | --------------------- |
| WebSocket | ✅     | `gossamer/web_socket` |

## ECMAScript Built-ins (no Gleam equivalent)

| Interface         | Status | Module                         |
| ----------------- | ------ | ------------------------------ |
| Promise           | ✅     | `gossamer/promise`             |
| ArrayBuffer       | ✅     | `gossamer/array_buffer`        |
| Int8Array         | ✅     | `gossamer/int8_array`          |
| Uint8Array        | ✅     | `gossamer/uint8_array`         |
| Uint8ClampedArray | ✅     | `gossamer/uint8_clamped_array` |
| Int16Array        | ✅     | `gossamer/int16_array`         |
| Uint16Array       | ✅     | `gossamer/uint16_array`        |
| Int32Array        | ✅     | `gossamer/int32_array`         |
| Uint32Array       | ✅     | `gossamer/uint32_array`        |
| Float16Array      | ✅     | `gossamer/float16_array`       |
| Float32Array      | ✅     | `gossamer/float32_array`       |
| Float64Array      | ✅     | `gossamer/float64_array`       |
| BigInt64Array     | ✅     | `gossamer/bigint64_array`      |
| BigUint64Array    | ✅     | `gossamer/biguint64_array`     |
| DataView          | ✅     | `gossamer/data_view`           |
| Iterator          | ✅     | `gossamer/iterator`            |
| AsyncIterator     | ✅     | `gossamer/async_iterator`      |
| JSON              | ✅     | `gossamer/json`                |
| Date              | ✅     | `gossamer/date`                |
| RegExp            | ✅     | `gossamer/regexp`              |
| Symbol            | ✅     | `gossamer/symbol`              |
| Number            | ✅     | `gossamer/number`              |
| BigInt            | 🚧     | `gossamer/big_int`             |
| Math              | ✅     | `gossamer/math`                |
| Error types       | ✅     | `gossamer/js_error`            |

## ECMAScript Built-ins (complements Gleam equivalents)

Gleam has conceptual equivalents for these, but they are not the native JS
types. These bindings enable interop with JS APIs that return or accept native
types, and expose functionality Gleam's stdlib doesn't cover.

| Interface            | Status | Module                           |
| -------------------- | ------ | -------------------------------- |
| Map                  | ✅     | `gossamer/map`                   |
| Set                  | ✅     | `gossamer/set`                   |
| WeakMap              | ✅     | `gossamer/weak_map`              |
| WeakSet              | ✅     | `gossamer/weak_set`              |
| WeakRef              | ✅     | `gossamer/weak_ref`              |
| FinalizationRegistry | ✅     | `gossamer/finalization_registry` |
| Array                | ✅     | `gossamer/array`                 |
| String               | ✅     | `gossamer/string`                |

## Out of Scope

| Category                                   | Reason                                                  |
| ------------------------------------------ | ------------------------------------------------------- |
| DOM APIs (document, window, Element, etc.) | Browser-only                                            |
| WebAssembly                                | Warrants its own package                                |
| Proxy, Reflect                             | Metaprogramming, not expressible in Gleam's type system |
| SharedArrayBuffer, Atomics                 | Threading; revisit if Workers become cross-runtime      |
| Generator, AsyncGenerator                  | Iterator creation via protocol is sufficient            |
