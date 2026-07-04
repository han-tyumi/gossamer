# Contributing

## Prerequisites

Tool versions are pinned in [`mise.toml`](./mise.toml), with download checksums
locked in `mise.lock`. With [mise](https://mise.jdx.dev/getting-started.html)
installed:

```sh
mise install
```

Or install each tool manually at the pinned version:

- [Bun](https://bun.sh/docs/installation)
- [Deno](https://docs.deno.com/runtime/getting_started/installation/)
- [Erlang](https://www.erlang.org/downloads)
- [Gleam](https://gleam.run/install/)
- [Just](https://just.systems/man/en/installation.html)
- [Lefthook](https://lefthook.dev/#how-to-install-lefthook)
- [Node.js](https://nodejs.org/en/download)
- [Rebar3](https://rebar3.org/docs/getting-started/)
- [Watchexec](https://github.com/watchexec/watchexec#install)

## Initial setup

```sh
just
```

## Development

```sh
just watch build test
```

## Commits and releases

Commits use [Conventional Commits](https://www.conventionalcommits.org/) —
[knope](https://knope.tech/) reads them to generate the changelog section and
bump the version. To release, run from a clean `main`:

```sh
just release
```

The recipe sources a fresh GitHub token from `gh auth token`, validates
credentials before the gate runs, and hands off to knope, which gates (branch,
clean tree, `just gate`, README badge sync), prepares the release commit
(changelog + version + example locks), tags, creates the GitHub release, and
publishes — see `knope.toml` for the workflow.

Hex authentication uses the `gleam hex authenticate` login by default. To
publish with an API key instead, store one in the macOS Keychain once —
`security add-generic-password -a "$USER" -s hexpm-gossamer-publish -w` — and
the recipe picks it up and validates it automatically; delete the entry to
return to the OAuth login.

For a release whose changelog entry is hand-curated (like 10.0.0), commit the
`CHANGELOG.md` section and `gleam.toml` version by hand and drop the
`PrepareRelease` step for that run.

## Conventions for adding bindings

Detailed conventions live under [`docs/contributing/`](./docs/contributing/).
Each page cross-links to related ones; start anywhere. The user-facing summary
is [`docs/conventions.md`](./docs/conventions.md).

## Handling runtime divergence

Web APIs sometimes diverge across Node.js, Deno, Bun, and browsers — a method
that exists on one runtime is missing on another, a getter returns `undefined`
where the spec defines a value, etc. gossamer handles these with two patterns so
the public Gleam API stays clean and divergence is diagnosable rather than
silent.

Spec-defined throws on **all** runtimes are a different concern — those are
wrapped in `Result(_, ModuleError)` at the binding. This section covers the
cross-runtime case where the spec works on most runtimes but not all.

### Decision tree

```
Is the divergence a spec-defined throw on all runtimes?
├── yes → not a runtime gap. Wrap in Result. Stop.
└── no  → continue.

Is the runtime gap fixable upstream (open tracking issue, the runtime
acknowledges it)?
├── no  → consider removing the binding if support isn't majority.
└── yes → continue.

Does the property have a meaningful spec default (a named variant,
`String`, `Bool`, or numeric)?
├── yes → Pattern 1: substitute the spec default in the FFI converter.
└── no  → continue.

Is this a missing method (call would throw `TypeError: undefined is not
a function`)?
└── yes → Pattern 2: diagnostic FFI throw via `ensureMethod`.
```

Either pattern requires a doc note on the Gleam binding (see
[Documenting the divergence](#documenting-the-divergence) below) and an entry in
[`docs/runtime-gaps.md`](./docs/runtime-gaps.md) so the consolidated catalog
stays current.

### Pattern 1 — Spec default at the FFI boundary

When the spec defines a meaningful default for an unset property (a named
variant, `""`, `false`, etc.), the FFI converter substitutes the spec default
when the runtime returns `undefined`. The Gleam binding's type signature stays
clean.

Example: `request.referrer` defaults to `"about:client"` per spec; some runtimes
return `undefined` instead. The FFI substitutes:

```typescript
export const referrer: typeof $request.referrer = (request) => {
  return request.referrer ?? "about:client";
};
```

### Pattern 2 — Diagnostic FFI throw

When a method doesn't exist on a runtime, calling it would throw
`TypeError: undefined is not a function`. gossamer intercepts at the FFI and
throws a more diagnostic error naming the binding, the runtime, and the upstream
issue. The Gleam type signature stays unchanged; consumers know the call may
panic from the doc note.

Example: `ReadableStream.from` is missing on Bun. The FFI guards with the shared
`ensureMethod` helper:

```typescript
export const from_yielder: typeof $readableStream.from_yielder = (
  yielder,
) => {
  ensureMethod(
    ReadableStream,
    "from",
    "readable_stream.from_yielder",
    "https://github.com/oven-sh/bun/issues/3700",
  );
  return ReadableStream.from(yielder);
};
```

### Documenting the divergence

Lead the Gleam binding's doc comment with the noun-phrase description, then
state the per-runtime observed value (Pattern 1) or panic condition (Pattern 2):

```gleam
/// The cache mode. Always `request_cache.Default` on Deno.
pub fn cache(of request: Request) -> RequestCache

/// Creates a `ReadableStream` from a `Yielder`. Panics on Bun — see
/// https://github.com/oven-sh/bun/issues/3700.
pub fn from_yielder(yielder: Yielder(a)) -> ReadableStream(a)
```

Then add a matching entry under the appropriate runtime in
[`docs/runtime-gaps.md`](./docs/runtime-gaps.md) so the consolidated catalog
stays in sync with the per-binding docs.

### Verification process

When applying this policy to a new gap:

1. **Empirically verify** the divergence on every runtime (Deno, Node, Bun) with
   `deno eval` / `node -e` / `bun -e`. Don't trust spec wording or third-party
   docs alone.
2. **Find the upstream tracking issue** (Deno / Bun / Node GitHub repos).
   Confirm it's open and active. If not, consider removing the binding instead.
3. **Pick Pattern 1 or 2** based on whether a meaningful spec default exists.
4. **Add the doc note** on the Gleam binding (see
   [Documenting the divergence](#documenting-the-divergence) above).
5. **Add an entry** in [`docs/runtime-gaps.md`](./docs/runtime-gaps.md) under
   the relevant runtime.
6. **Write a test** that asserts the documented behavior. Pair `skip_on(<bad>)`
   with `only_on(<bad>)` asserting the buggy value so the test fails when the
   upstream fix lands. For Pattern 1, the `only_on` test observes the default;
   for Pattern 2, it asserts the thrown error's message contains the binding
   name.

### What gossamer doesn't do

- **No `Result` wrap purely for runtime divergence.** That would add unwrap
  noise on every call on every runtime and create a breaking change if the gap
  closes upstream. `Result` is for input-driven spec-defined failures only.
- **No silent fallback for missing methods or non-honest defaults.** A
  capability gap (Pattern 2) or a content-derived field with no meaningful unset
  value fails loudly via the diagnostic throw rather than masking the
  divergence.

## Verifying runtime floors

`runtime.toml` records the minimum Node.js/Deno/Bun versions where `gleam test`
passes. After source or dep changes, run

```sh
./scripts/find-runtime-floor.sh
```

to verify the recorded floors still hold. The script walks forward if the floor
regressed and walks backward if a fix lowered it. Updates to `runtime.toml` are
auto-rendered into the README badges via the `floors-render` lefthook hook.
