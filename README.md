# gossamer 🕸️

Cross-runtime JavaScript API bindings for [Gleam](https://gleam.run/).

[![Package Version](https://img.shields.io/hexpm/v/gossamer)](https://hex.pm/packages/gossamer)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gossamer/)

gossamer covers Web Platform APIs
([WinterTC](https://min-common-api.proposal.wintertc.org/)) and ECMAScript
built-ins that don't have idiomatic Gleam wrappers yet. Bindings work across
Deno, Node.js, Bun, and browsers without polyfills.

## Reach for ecosystem packages first

gossamer is gap-fill. Where the Gleam ecosystem already covers a domain, use its
canonical types and functions directly:

| Domain                                     | Use this                                                      |
| ------------------------------------------ | ------------------------------------------------------------- |
| HTTP requests, responses, methods, headers | [`gleam_http`](https://hexdocs.pm/gleam_http/)                |
| `fetch`                                    | [`gleam_fetch`](https://hexdocs.pm/gleam_fetch/)              |
| URLs (RFC 3986 parsing, building)          | [`gleam/uri`](https://hexdocs.pm/gleam_stdlib/gleam/uri.html) |
| Timestamps and durations                   | [`gleam_time`](https://hexdocs.pm/gleam_time/)                |
| JSON                                       | [`gleam_json`](https://hexdocs.pm/gleam_json/)                |
| `Promise`, `Array`, `Symbol`               | [`gleam_javascript`](https://hexdocs.pm/gleam_javascript/)    |
| Iterators                                  | [`gleam_yielder`](https://hexdocs.pm/gleam_yielder/)          |
| Regular expressions                        | [`gleam_regexp`](https://hexdocs.pm/gleam_regexp/)            |
| Strong random bytes                        | [`gleam_crypto`](https://hexdocs.pm/gleam_crypto/)            |

gossamer fills the rest: `AbortSignal`, `Blob` / `File`, the Streams API,
`SubtleCrypto`, `WebSocket`, `Worker` / `MessageChannel` / `BroadcastChannel`,
`Intl` formatters, `TextDecoder` / `TextDecoderStream` / `TextEncoderStream`,
`CompressionStream` / `DecompressionStream`, `URLPattern`, `BigInt`,
`Performance` / `PerformanceObserver`, plus per-module extras (`fetch_extra`,
`form_data_extra`, `time_extra`, `string_extra`, `regexp_extra`, `symbol_extra`,
`int_extra`, `float_extra`). See the
[coverage page](https://hexdocs.pm/gossamer/coverage.html) for the full list.

Per-binding docs flag cross-runtime gaps where a runtime departs from spec.

## Installation

```sh
gleam add gossamer
```

## Usage

A fetch through `gossamer/fetch_extra` with cache and keepalive overrides —
chain setters on the `FetchOptions` builder, then pass it to `send`. The result
composes with `gleam/fetch`'s body readers:

```gleam
import gleam/fetch
import gleam/http/request
import gleam/javascript/promise
import gossamer/fetch_extra

pub fn main() {
  let assert Ok(req) = request.to("https://example.com/api")
  let opts =
    fetch_extra.options()
    |> fetch_extra.set_cache(fetch_extra.CacheNoStore)
    |> fetch_extra.set_keepalive(True)
  use resp <- promise.try_await(fetch_extra.send(req, with: opts))
  use resp <- promise.try_await(fetch.read_text_body(resp))
  promise.resolve(Ok(resp.body))
}
```

Further documentation lives at <https://hexdocs.pm/gossamer>.

## Contributing

### Prerequisites

- [Deno](https://docs.deno.com/runtime/getting_started/installation/)
- [Erlang](https://www.erlang.org/downloads)
- [Gleam](https://gleam.run/install/)
- [Just](https://just.systems/man/en/installation.html)
- [Lefthook](https://lefthook.dev/#how-to-install-lefthook)
- [Rebar3](https://rebar3.org/docs/getting-started/)
- [Watchexec](https://github.com/watchexec/watchexec#install)

_Tip_: These can also be installed via
[mise](https://mise.jdx.dev/getting-started.html) or
[asdf](https://asdf-vm.com/guide/getting-started.html), which read from
`.tool-versions`.

### Initial Setup

```sh
just
```

### Development

```sh
just watch build test
```

### Commits & Releases

Commits use [Conventional Commits](https://www.conventionalcommits.org/).
[knope](https://knope.tech/) reads them to generate the changelog and bump the
version — see `knope.toml` for the release workflow. Run `knope release` from a
clean `main` to release.
