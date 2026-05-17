# Throw detection

Gossamer's "no unsafe variants" philosophy requires every throwable JS API to be
wrapped in `Result` at the FFI boundary. But JS throws aren't visible in method
signatures — they're documented in spec algorithms and MDN exception sections.
This page is the process to catch them at binding time.

Companion to [runtime gaps](../runtime-gaps.md) and
[Handling runtime divergence](../../CONTRIBUTING.md#handling-runtime-divergence).
This page covers spec-defined throws on **all** runtimes; runtime divergence
covers cases where one runtime fails to implement the spec.

## Why this is hard

- WebIDL `undefined append(ByteString name, ByteString value)` tells you nothing
  about throws — `headers.append` throws `TypeError` on invalid bytes.
- TypeScript `lib.dom.d.ts` rarely marks throws explicitly.
- Happy-path usage never triggers the throw, so tests alone won't catch it.

## Checklist for every new binding

When binding a Web API method, ask:

1. **Input validation:** Does the method accept strings/bytes that must match a
   grammar? (`ByteString`, URL, algorithm name, HTTP method, header name, etc.)
2. **Allocation:** Does it allocate memory that could fail? (`ArrayBuffer`,
   `TypedArray` sizes, large `Blob` parts.)
3. **Required state:** Does it require the object to be in a specific state?
   (Stream locked / closed, key usage bits, connection open, `Promise` pending.)
4. **MDN Exceptions section:** Does the MDN page have an "Exceptions" section?
   Read it. If present, it lists what throws.
5. **Spec algorithm "throw":** Grep the spec for "throw" — WHATWG, W3C, TC39
   algorithms describe throws in prose steps.

**If any answer is yes → wrap in `Result` at the FFI.**

Default bias: **assume it throws until proven otherwise.** Cheaper to wrap
unnecessarily than to leak an exception.

## Reliable sources (in order)

1. **MDN "Exceptions" section** — most accessible, usually complete. Look for
   the heading on the method's MDN page.
2. **Spec algorithm steps** — WHATWG / W3C / TC39. Search for "throw" in the
   relevant algorithm.
3. **WebIDL `[Throws]` extended attribute** — only on some methods.

## For Promises

A `Promise` in JS can reject. If the spec says the promise rejects on error:

- Return `Promise(Result(a, ModuleError))` if it can reject with an error.
- Return `Promise(a)` only when the spec guarantees no rejection.

Examples that reject: `fetch`, `response.text()`, `reader.read()`,
`reader.closed`, `writable_stream.close()`, `readable_stream.pipe_to()`.

## Over-wrapping is also wrong

Don't wrap methods that don't throw. It's false signal and annoying for
consumers. If MDN has no "Exceptions" section and the spec has no "throw" for
the method, return the raw type.

## Verifying existing bindings

When auditing a module:

1. List every `@external` function.
2. For each, find its MDN page → check "Exceptions".
3. For each, find its spec algorithm → check for "throw" or "reject".
4. Compare against the Gleam return type:
   - Throws but returns direct value → **under-wrapped, bug**.
   - No throws but returns `Result` → **over-wrapped, noise**.
   - Matches → OK.
5. **For each throw condition, write a test that triggers it.** This is
   non-negotiable. Happy-path tests pass even when the FFI is unwrapped — only a
   throw-triggering test surfaces the bug. If the binding returns
   `Result(_, _)`, assert `Error(_)` for the bad input.

Pattern for a throw-path test on a wrapped binding:

```gleam
pub fn from_string_invalid_test() {
  let assert Error(_) = big_int.from_string("not a number")
  let assert Error(_) = big_int.from_string("1.5")
}
```

### Verify spec-throw claims empirically

Before treating any "API X throws on Y" claim as fact, run it on every runtime:

```sh
deno eval '...'
node -e '...'
bun -e '...'
```

Specs are sometimes ambiguous and MDN sometimes contradicts the implementation.
Test before believing.

## Handling throws — policy

When a function has a throw condition, apply these in order:

**1. Type-prevent** where the valid inputs form an enumerable set.

- `compression_stream.new` accepts `CompressionFormat` enum (only valid
  formats).
- `readable_stream.from_yielder` accepts a `Yielder` (can't be non-iterable).
- Applies at the API shape level — no runtime checks.

**2. `Result`** for remaining throw paths.

- Use `Result(T, ModuleError)` for synchronous throws.
- Use `Promise(Result(T, ModuleError))` for rejectable Promises.
- Wrap at the FFI boundary using `toResult.fromThrows` or `toResult.fromPromise`
  in `src/utils/result.ffi.ts`.

**Do not silently clip or default invalid runtime inputs.** No `-1 → 0`
conversions in FFI. The library's principle is consistency: if JS throws, the
function returns `Result`. Users opt in with `let assert Ok(_) = ...` when
confident.

Type-prevention is separate from clipping — it's a design-time choice (stronger
types), not a runtime silent fix. Type-prevention is encouraged. Clipping is
not.

## Typed error sums

`Result`-returning bindings declare per-binding (or per-domain) typed error
sums. `gossamer/crypto.CryptoError` is the canonical in-repo example, covering
the Web Crypto family:

```gleam
pub type CryptoError {
  KeyUsageMismatch(usage: KeyUsage)
  KeyNotExtractable
  AlgorithmNotSupported
  InvalidAccess
  OperationFailed
  DataMalformed
  QuotaExceeded
  InvalidSyntax
}

pub fn derive_bits(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  length length: Int,
) -> Promise(Result(BitArray, CryptoError))
```

Mixed payload rule:

- **Tag-only** when the variant identifies one specific cause.
- **Typed payload** (`String`, enum) when the variant covers multiple cases
  within a category.

The variants mirror the JS spec's failure modes (`NotSupportedError`,
`InvalidAccessError`, `OperationError`, etc.) wrapped as Gleam constructors,
each one a closed sum.

This follows
[`gleam/fetch.FetchError`](https://hexdocs.pm/gleam_fetch/gleam/fetch.html#FetchError)
and aligns with the
[Gleam conventions doc](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/#design-descriptive-errors)
on descriptive errors.

## Rationale for no clipping

Considered and rejected:

- Makes one-off functions inconsistent (why does `string.repeat(-1)` return `""`
  but `uint8_array.from_length(-1)` return `Error`?).
- Risks masking bugs (silent empty buffer propagating through binary code).
- Adds documentation burden (every clipped function needs a note about its
  divergence).

Benefits of `Result`-only:

- One mental model: JS throws → `Result`.
- No divergence documentation per function.
- Users handle errors explicitly or opt out with `let assert`.

## See also

- [Conventions](../conventions.md) — typed errors at a glance.
- [Handling runtime divergence](../../CONTRIBUTING.md#handling-runtime-divergence)
  — sibling concept for cross-runtime gaps.
- [Doc comments](./doc-comments.md) — how to phrase the error doc comment on
  `Result`-returning bindings.
