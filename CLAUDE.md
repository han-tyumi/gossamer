# CLAUDE.md

Guidance for Claude Code working in this repository. Read
[README.md](./README.md) for the project overview and usage example, and
[`docs/coverage.md`](./docs/coverage.md) for what gossamer wraps and what's
explicitly out of scope.

## Philosophy

- **Ecosystem-first, gap-fill the spec.** Use canonical Gleam types
  (`gleam/uri.Uri`, `BitArray`, `gleam/javascript/promise.Promise`,
  `gleam/http.Method`, `gleam_time.Timestamp`) where the ecosystem covers the
  domain; gossamer fills the spec gaps (Fetch-spec init dict, `AbortSignal`,
  streams, `SubtleCrypto`, `EventTarget`, `WebSocket`, etc.).
- **No unsafe variants.** Throwing JS APIs are wrapped in `Result` at the FFI
  boundary with per-binding typed error sums. See
  [Throw detection](./docs/contributing/throw-detection.md).
- **Runtime divergence ≠ Result.** Cross-runtime gaps follow a separate
  panic-dominant policy. See
  [Handling runtime divergence](./CONTRIBUTING.md#handling-runtime-divergence).
  Never use `Result` purely for runtime divergence.
- **No aliases.** One name per operation. `is_` prefix and `snake_case` are
  mechanical adaptations, not renames.
- **Builder pattern over init lists.** No `*Init` wrapper types, no options-list
  parameters, no `_with_<name>` suffixes (on either functions or variants). See
  [Builder patterns](./docs/contributing/builder-patterns.md).
- **Lower-level JS types stay when they add value.** `Uint8Array`,
  `ArrayBuffer`, JS `Array` etc. stay when their semantics aren't expressible in
  the canonical Gleam type. Provide bridges (`to_bit_array` / `from_bit_array`)
  for conversion.

## Commands

```sh
just bootstrap          # initial setup
just watch build test   # dev loop with watch mode
just build              # compile TS FFI + Gleam
just test               # run tests on Deno, Node.js, Bun
just check              # type-check TypeScript
just format             # format all code
just docs               # generate docs
just clean              # clean build artifacts
```

## See also

- [CONTRIBUTING](./CONTRIBUTING.md) — setup, runtime-divergence policy, and
  release flow.
- [`docs/conventions.md`](./docs/conventions.md) — user-facing summary of the
  API patterns.
- [`docs/contributing/api-mapping.md`](./docs/contributing/api-mapping.md) —
  detailed JS-to-Gleam mapping reference (constructors, getters, methods,
  errors, callbacks).
- [`docs/contributing/ffi-architecture.md`](./docs/contributing/ffi-architecture.md)
  — FFI pattern, build process, type-annotation split, utilities.
- [`docs/contributing/`](./docs/contributing/) — the rest of the convention
  catalog (builder patterns, typed variants, module organization, throw
  detection, doc comments, labels).
- [`docs/runtime-gaps.md`](./docs/runtime-gaps.md) — catalog of known
  cross-runtime divergences.
