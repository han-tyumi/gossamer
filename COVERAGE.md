# Coverage

gossamer targets cross-runtime JavaScript APIs — both
[Web Platform](https://min-common-api.proposal.wintertc.org/) and
[ECMAScript](https://tc39.es/ecma262/) — that have no direct equivalent in
Gleam's standard library. All APIs must work in Deno, Node.js, Bun, and
browsers.

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

| Interface | Status | Module               | Notes                          |
| --------- | ------ | -------------------- | ------------------------------ |
| fetch()   | ✅     | `gossamer`           |                                |
| Headers   | ✅     | `gossamer/headers`   |                                |
| Request   | 🚧     | `gossamer/request`   | Missing `blob()`, `formData()` |
| Response  | 🚧     | `gossamer/response`  | Missing `blob()`, `formData()` |
| FormData  | ✅     | `gossamer/form_data` |                                |

### URL

| Interface       | Status | Module                       | Notes                                                         |
| --------------- | ------ | ---------------------------- | ------------------------------------------------------------- |
| URL             | 🚧     | `gossamer/url`               | Missing `createObjectURL()`, `revokeObjectURL()` (verify Bun) |
| URLSearchParams | ✅     | `gossamer/url_search_params` |                                                               |
| URLPattern      | ❌     | —                            |                                                               |

### Streams

| Interface                        | Status | Module                                         | Notes |
| -------------------------------- | ------ | ---------------------------------------------- | ----- |
| ReadableStream                   | ✅     | `gossamer/readable_stream`                     |       |
| ReadableStreamDefaultReader      | ✅     | `gossamer/readable_stream/reader`              |       |
| ReadableStreamBYOBReader         | ✅     | `gossamer/readable_stream/byob_reader`         |       |
| ReadableStreamDefaultController  | ✅     | `gossamer/readable_stream/default_controller`  |       |
| WritableStream                   | ✅     | `gossamer/writable_stream`                     |       |
| WritableStreamDefaultWriter      | ✅     | `gossamer/writable_stream/writer`              |       |
| WritableStreamDefaultController  | ✅     | `gossamer/writable_stream/default_controller`  |       |
| TransformStream                  | ✅     | `gossamer/transform_stream`                    |       |
| TransformStreamDefaultController | ✅     | `gossamer/transform_stream/default_controller` |       |
| ByteLengthQueuingStrategy        | ❌     | —                                              |       |
| CountQueuingStrategy             | ❌     | —                                              |       |

### Compression

| Interface           | Status | Module                          | Notes |
| ------------------- | ------ | ------------------------------- | ----- |
| CompressionStream   | ✅     | `gossamer/compression_stream`   |       |
| DecompressionStream | ✅     | `gossamer/decompression_stream` |       |

### Text Encoding

| Interface         | Status | Module                         | Notes                   |
| ----------------- | ------ | ------------------------------ | ----------------------- |
| TextEncoder       | 🚧     | `gossamer/text_encoder`        | Missing `encoding` prop |
| TextDecoder       | ✅     | `gossamer/text_decoder`        |                         |
| TextEncoderStream | ✅     | `gossamer/text_encoder_stream` |                         |
| TextDecoderStream | ✅     | `gossamer/text_decoder_stream` |                         |

### Crypto

| Interface    | Status | Module                   | Notes |
| ------------ | ------ | ------------------------ | ----- |
| Crypto       | ✅     | `gossamer/crypto`        |       |
| SubtleCrypto | ✅     | `gossamer/subtle_crypto` |       |
| CryptoKey    | ✅     | `gossamer/crypto_key`    |       |

### Data Types

| Interface | Status | Module          | Notes                                                  |
| --------- | ------ | --------------- | ------------------------------------------------------ |
| Blob      | ✅     | `gossamer/blob` |                                                        |
| File      | 🚧     | `gossamer/file` | Missing constructor options, no inherited Blob methods |

### Events & DOM

| Interface             | Status | Module | Notes |
| --------------------- | ------ | ------ | ----- |
| Event                 | ❌     | —      |       |
| EventTarget           | ❌     | —      |       |
| CustomEvent           | ❌     | —      |       |
| ErrorEvent            | ❌     | —      |       |
| PromiseRejectionEvent | ❌     | —      |       |
| DOMException          | ❌     | —      |       |

### Cancellation

| Interface       | Status | Module                      | Notes                                                      |
| --------------- | ------ | --------------------------- | ---------------------------------------------------------- |
| AbortController | ✅     | `gossamer/abort_controller` |                                                            |
| AbortSignal     | 🚧     | `gossamer/abort_signal`     | Missing `aborted`, `reason`, `throwIfAborted()`, `onabort` |

### Messaging

| Interface      | Status | Module                   | Notes |
| -------------- | ------ | ------------------------ | ----- |
| MessageChannel | ❌     | —                        |       |
| MessagePort    | ❌     | —                        |       |
| MessageEvent   | ✅     | `gossamer/message_event` |       |

### Timers & Scheduling

| Interface      | Status | Module     | Notes |
| -------------- | ------ | ---------- | ----- |
| setTimeout     | ✅     | `gossamer` |       |
| setInterval    | ✅     | `gossamer` |       |
| clearTimeout   | ✅     | `gossamer` |       |
| clearInterval  | ✅     | `gossamer` |       |
| queueMicrotask | ✅     | `gossamer` |       |

### Utilities

| Interface           | Status | Module     | Notes |
| ------------------- | ------ | ---------- | ----- |
| structuredClone     | ❌     | —          |       |
| atob / btoa         | ❌     | —          |       |
| reportError         | ✅     | `gossamer` |       |
| console             | ❌     | —          |       |
| Performance         | ❌     | —          |       |
| navigator.userAgent | ❌     | —          |       |

## Cross-Runtime Web APIs (beyond WinterTC minimum)

| Interface | Status | Module                | Notes                         |
| --------- | ------ | --------------------- | ----------------------------- |
| WebSocket | 🚧     | `gossamer/web_socket` | Missing ready state constants |

## ECMAScript Built-ins (no Gleam equivalent)

| Interface     | Status | Module                    | Notes                                                             |
| ------------- | ------ | ------------------------- | ----------------------------------------------------------------- |
| Promise       | 🚧     | `gossamer/promise`        | Missing `try()`                                                   |
| Uint8Array    | 🚧     | `gossamer/uint8_array`    | Missing `from()`, `of()`, `entries()`, `keys()`, `values()`       |
| ArrayBuffer   | 🚧     | `gossamer/array_buffer`   | Missing `isView()`, `detached`, `resize()`, `transfer()` and more |
| Iterator      | ✅     | `gossamer/iterator`       |                                                                   |
| AsyncIterator | ✅     | `gossamer/async_iterator` |                                                                   |
| JSON          | ✅     | `gossamer/json`           |                                                                   |
| Date          | 🚧     | `gossamer` (type only)    |                                                                   |
| RegExp        | ❌     | —                         |                                                                   |
| Error types   | ❌     | —                         |                                                                   |

## Out of Scope

| Category                                        | Reason                                                     |
| ----------------------------------------------- | ---------------------------------------------------------- |
| Map, Set, Array, String, Number, Math           | Gleam has equivalents (Dict, Set, List, string, int/float) |
| DOM APIs (document, window, Element, etc.)      | Browser-only                                               |
| WebAssembly                                     | Warrants its own package                                   |
| Runtime-specific (Deno.\*, process.\*, etc.)    | Not cross-runtime                                          |
| Proxy, Reflect, SharedArrayBuffer, Atomics      | Metaprogramming / threading, not useful from Gleam         |
| WeakMap, WeakSet, WeakRef, FinalizationRegistry | GC primitives, rarely needed                               |
| Generator, AsyncGenerator                       | Gleam has its own patterns                                 |
