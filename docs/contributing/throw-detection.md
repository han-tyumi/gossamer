# Throw detection

Gossamer's "no unsafe variants" philosophy requires every throwable JS API to be
handled deliberately at the FFI boundary — most commonly wrapped in `Result`.
But JS throws aren't visible in method signatures — they're documented in spec
algorithms and MDN exception sections. This page is the process to catch them at
binding time.

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

**If any answer is yes → the function has a failure path; pick its handling from
the policy below.**

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

**1. Type-prevent** where the valid inputs form a closed set.

- `compression_stream.new` accepts a `CompressionFormat` (only valid formats).
- `readable_stream.from_yielder` accepts a `Yielder` (can't be non-iterable).
- Applies at the API shape level — no runtime checks.

**2. Clamp non-positive length, count, and time-offset parameters** to the empty
value, matching the stdlib convention (`string.repeat(s, -1)` returns `""`;
`list.take(list, -1)` returns `[]`). A negative quantity is a programmer error
with a harmless identity result; a `Result` wrap would tax every call site for a
failure that carries no information. Document the clamp on the binding
("Negative inputs are clamped to zero."). Sanctioned clamps:

- The `performance` family — `mark.at`, `mark.set_start_time`,
  `measure.between`, `measure.set_start_time`, and `measure.set_duration` clamp
  negative times to zero.
- `array_buffer.new` — a non-positive `byte_length` returns an empty buffer.
- `big_int.as_int_n` / `as_uint_n` — a `bits` of `0` or less yields `0`.

Clamping applies to quantity parameters only. **Content-derived values are never
silently defaulted** — a malformed locale tag, key, or URL string means
something the caller needs surfaced, not absorbed.

**3. Documented panic** is reserved for two cases. Runtime compatibility — a
capability missing on a minority runtime, where a `Result` would tax the
runtimes that work (see
[Handling runtime divergence](../../CONTRIBUTING.md#handling-runtime-divergence)).
And engine capacity — allocation-style limits such as the maximum `ArrayBuffer`
length or the `BigInt` size cap, which the stdlib convention treats like any
other resource exhaustion and lets crash (`string.repeat` at the engine's
maximum string length behaves the same way). Document the panic condition on the
binding.

**4. `Result`** for deterministic input-domain failures — anything knowable from
the input alone: malformed input a caller may plausibly supply (locale tags,
patterns, key data), state errors (locked streams, unusable keys), and
spec-constant domain limits even when unrealistic (the JS `Date` range, the
ECMA-402 duration limit). The stdlib guards every deterministic input failure in
its own FFI (`bit_array_to_string`, `percent_decode`, `parse_query`,
`base64_decode`); gossamer follows suit.

- Use `Result(T, ModuleError)` for synchronous throws.
- Use `Promise(Result(T, ModuleError))` for rejectable Promises.
- Wrap at the FFI boundary using `toResult.fromThrows` or `toResult.fromPromise`
  in `src/utils/result.ffi.ts`.
- Users opt out with `let assert Ok(_) = ...` when confident.

Type-prevention and clamping are design-time choices with documented outcomes,
not silent fixes. Don't add clamp sites beyond quantity parameters without
recording them in the sanctioned list above.

## Typed error variants

`Result`-returning bindings declare per-binding (or per-domain) typed error
types. `gossamer/crypto.CryptoError` is the canonical in-repo example, covering
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
- **Typed payload** (`String`, a sibling variant type) when the variant covers
  multiple cases within a category.

The variants mirror the JS spec's failure modes (`NotSupportedError`,
`InvalidAccessError`, `OperationError`, etc.) as named Gleam variants, each type
a closed set.

This follows
[`gleam/fetch.FetchError`](https://hexdocs.pm/gleam_fetch/gleam/fetch.html#FetchError)
and aligns with the
[Gleam conventions doc](https://gleam.run/documentation/conventions-patterns-and-anti-patterns/#design-descriptive-errors)
on descriptive errors.

## Rationale for the clamp / panic / `Result` split

- **Clamping quantities matches the stdlib.** `string.repeat`, `list.repeat`,
  `list.take`, and `list.drop` all absorb non-positive counts. A binding that
  `Result`-wrapped the same shape would be the inconsistent one, and every
  caller would pay an unwrap for a programmer-error path.
- **Content is never clamped.** Substituting a default for a malformed locale
  tag or URL string masks bugs — the silent wrong value propagates. Malformed
  content is a realistic input and returns `Result`.
- **The panic line is compatibility and capacity, not magnitude.** A
  deterministic domain limit is knowable from the input, so it returns `Result`
  no matter how unrealistic the input — that's the stdlib's own FFI posture.
  Capacity failures (allocation limits) depend on the engine, not the input, and
  no ecosystem library wraps resource exhaustion.

## See also

- [Conventions](../conventions.md) — typed errors at a glance.
- [Handling runtime divergence](../../CONTRIBUTING.md#handling-runtime-divergence)
  — sibling concept for cross-runtime gaps.
- [Doc comments](./doc-comments.md) — how to phrase the error doc comment on
  `Result`-returning bindings.
