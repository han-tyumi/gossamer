# gossamer

Web API bindings for [Gleam](https://gleam.run/), targeting JavaScript runtimes
(Deno, Node.js, Bun, and browsers).

[![Package Version](https://img.shields.io/hexpm/v/gossamer)](https://hex.pm/packages/gossamer)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gossamer/)

## Installation

```sh
gleam add gossamer
```

## Usage

```gleam
import gossamer
import gossamer/promise
import gossamer/response
import gossamer/url

pub fn main() {
  let parsed = url.new("https://example.com/path?q=gleam")
  let hostname = url.hostname(parsed)  // "example.com"

  use resp <- promise.then(gossamer.fetch("https://example.com"))
  use body <- promise.then(response.text(resp))
  promise.resolve(body)
}
```

## Modules

### Core Types

- **promise** — `Promise` with `then`, `catch`, `all`, `race`, `any`,
  `all_settled`, `with_resolvers`
- **uint8_array** — Complete `Uint8Array` API including base64/hex encoding
- **array_buffer** — `ArrayBuffer` bindings
- **blob** — `Blob` creation and reading
- **file** — `File` type (extends Blob)
- **json** — JSON parse/stringify with Gleam types

### Networking & HTTP

- **headers** — `Headers` with get/set/append/delete/keys/values/entries
- **request** — `Request` construction and properties
- **response** — `Response` construction, reading, and cloning
- **url** — `URL` parsing and manipulation
- **url_search_params** — Query string handling
- **web_socket** — `WebSocket` client with typed events
- **form_data** — `FormData` for multipart form handling

### Streams

- **readable_stream** — `ReadableStream` with reader/controller/piping
- **writable_stream** — `WritableStream` with writer/controller
- **transform_stream** — `TransformStream` with transformer
- **compression_stream** / **decompression_stream** — gzip/deflate/brotli

### Crypto

- **crypto** — `getRandomValues`, `randomUUID`
- **subtle_crypto** — digest, encrypt/decrypt, sign/verify, key
  generation/import/export, derive, wrap/unwrap
- **crypto_key** / **crypto_key_pair** — Key types and properties

### Text Encoding

- **text_encoder** / **text_decoder** — UTF-8 encoding/decoding
- **text_encoder_stream** / **text_decoder_stream** — Streaming variants

### Other

- **abort_controller** / **abort_signal** — Cancellation
- **iterator** / **async_iterator** — JS iterator protocol

### Top-level (`gossamer`)

- `fetch`, `fetch_with_init`, `fetch_request`
- `set_timeout`, `clear_timeout`, `set_interval`, `clear_interval`
- `queue_microtask`, `report_error`
- `alert`, `confirm`, `prompt`, `close`
