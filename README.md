# gossamer 🕸️

Cross-runtime JavaScript API bindings for [Gleam](https://gleam.run/).

[![Package Version](https://img.shields.io/hexpm/v/gossamer)](https://hex.pm/packages/gossamer)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gossamer/)

gossamer covers Web Platform APIs
([WinterTC](https://min-common-api.proposal.wintertc.org/)) and ECMAScript
built-ins, including native JS types that complement Gleam's standard library
for interop. All APIs work across Deno, Node.js, Bun, and browsers.

APIs mirror their JavaScript counterparts in structure and naming, adapted to
Gleam conventions — snake_case naming, pipeable signatures, `Result` for
throwing/nullable APIs, and `Promise(Result(a, e))` for rejectable promises.

For higher-level Gleam-idiomatic abstractions, see
[gleam_javascript](https://hexdocs.pm/gleam_javascript/),
[gleam_fetch](https://hexdocs.pm/gleam_fetch/), and
[gleam_json](https://hexdocs.pm/gleam_json/).

See [COVERAGE.md](COVERAGE.md) for the full list of implemented and planned
APIs.

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
  let assert Ok(parsed) = url.new("https://example.com/path?q=gleam")
  let hostname = url.hostname(parsed)  // "example.com"

  use result <- promise.then(gossamer.fetch("https://example.com"))
  let assert Ok(resp) = result
  use result <- promise.then(response.text(resp))
  let assert Ok(body) = result
  promise.resolve(body)
}
```

Further documentation can be found at <https://hexdocs.pm/gossamer>.

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
