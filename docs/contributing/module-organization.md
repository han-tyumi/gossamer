# Module organization

How to decide where a type lives in gossamer.

## The default — keep types with their producers and consumers

**When in doubt, keep the type in its consumer module.** The cost of merging
later is small; the cost of fragmentation up front is real.

Grounded in the official
[Gleam conventions doc](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/#fragmented-modules),
"Fragmented modules":

> Do not prematurely split up modules into multiple smaller modules, and do not
> view large modules as a problem. Instead focus on the business domain and
> making the best API for the users of the code.
>
> An API that is split over many modules is harder to understand and requires
> more boilerplate to use than one well designed module.

Confirmed empirically across the ecosystem:

- `gleam/http` — `Method` (10 variants and `Other`), `Scheme` (2 variants and
  `Other`) live in `gleam/http.gleam` alongside `Header` and other types.
- `gleam_json` — `DecodeError` (4 variants) lives in `gleam/json.gleam`
  alongside the opaque `Json` type.
- `gleam_time` — `Month` (12 bare variants) and `Date` / `TimeOfDay` records
  live in `gleam/time/calendar.gleam`. `Unit` (10 bare variants) lives in
  `gleam/time/duration.gleam` with `Duration`.
- `plinth` — small enums like `Position` (4 variants) live inline with their
  primary type.
- `gleam_fetch` — `FetchError` lives in `gleam/fetch.gleam` with the four
  `Fetch*` types.
- `gleam_stdlib` — `ContinueOrStop` lives in `gleam/list`.

## When to split

Split a type into its own module **only** when at least one of:

1. **The type is shared across two or more unrelated top-level modules.**
   Examples: `key_usage` used by `crypto_key`, `subtle_crypto`, AND
   `json_web_key`. `iterator_result` used by `iterator` AND `async_iterator`.
   Cross-cutting types earn their own module.

2. **The type has its own non-trivial API** — constructors, predicates, parsers,
   transforms. The module is the type's natural home, not a small auxiliary.

3. **Circular-import constraint forces it.** Sometimes a type referenced by an
   opaque-typed submodule must live in its own file to break the cycle (e.g.,
   `readable_stream/read_result`).

If none of these apply: keep the type in its consumer.

## Type categories (soft heuristics — not splitting guidance)

These categories are useful when reasoning about types but do **not** determine
module placement.

**Enum** — A type whose variants represent distinct states, modes, or
selections.

```gleam
pub type ReadyState { Connecting  Open  Closing  Closed }
pub type HttpMethod { Get  Post  Put  Other(String) }
```

**Record** — A single-variant type holding structured data fields.

```gleam
pub type CloseEvent {
  CloseEvent(code: Int, reason: String, was_clean: Bool)
}
```

**Outcome** — A multi-variant type returned by an operation, where variants
carry different payloads. Used in pattern matching.

```gleam
pub type PromiseSettledResult(a) {
  Fulfilled(value: a)
  Rejected(reason: Dynamic)
}
```

All categories default to living with their producers and consumers per the rule
above. None forces a separate module.

## Submodule placement

When a type does earn its own module (per the conditions above), it usually goes
top-level (`gossamer/<name>.gleam`). Consider a submodule
(`gossamer/<parent>/<name>.gleam`) only when:

- The type is opaque and exclusively obtained through a parent module's API.
  Examples in gossamer: `readable_stream/reader`, `readable_stream/byob_reader`,
  `readable_stream/default_controller` — only obtainable via `readable_stream`
  methods.
- Or the type's name is meaningless without the parent's context (rare).

Mirrors `gleam/http/request` + `gleam/http/response` under `gleam/http` —
submodules anchor distinct interface types under a shared namespace.

## Family-level parent modules

When two or more sibling modules in one domain share a type (often an error type
or core enum), use a parent module to host it. Submodules import on equal
footing.

Examples in gossamer:

- **stream** — 9 sibling submodules (readable + writable + transform streams,
  plus their readers, writers, and controllers) share `StreamLifecycleError`.
  Structure: `gossamer/stream.gleam` + `gossamer/stream/*`.
- **encoding** — 3 sibling submodules (`text_decoder` + `text_decoder_stream` +
  `text_encoder_stream`) share the `Encoding` enum and `DecoderError`.
  Structure: `gossamer/encoding.gleam` + `gossamer/encoding/*`.
- **compression** — 2 sibling submodules (`compression_stream` +
  `decompression_stream`) share the `CompressionFormat` enum. Structure:
  `gossamer/compression.gleam` + `gossamer/compression/*`.
- **crypto** — `crypto/key`, `crypto/subtle`, `crypto/jwk` share `KeyUsage`,
  `CryptoError`, and the algorithm enums. Structure: `gossamer/crypto.gleam` +
  `gossamer/crypto/*`.
- **iteration** — `iterator` + `async_iterator` share `IteratorResult`.
  Structure: `gossamer/iteration.gleam` + `gossamer/iteration/*`.

Mirrors `gleam/http.Method` exactly: type defined in parent module; submodules
import.

Without this structure, the alternatives are: identical-but-distinct error types
per submodule (heavy duplication) OR sibling sharing where one sibling "owns"
the type and others import from it (asymmetric coupling that invents a precedent
the ecosystem doesn't have). Parent-submodule structure resolves both problems
even at small family sizes.

**No-shared-type families flatten to top-level.** When a family has no shared
type or enum (only sibling modules grouped by domain), the parent module
disappears and the siblings move to the top level. `array_buffer` and
`uint8_array` are both byte-buffer bindings, but neither hosts a shared type the
other needs — they live as `gossamer/array_buffer` and `gossamer/uint8_array`,
not under a `buffer/` subdirectory.

## Constraints

**Constructor uniqueness:** Gleam requires all constructor names in a module to
be unique. If merging two enums into one module produces a collision, rename one
of the colliding variants. The most common collision source is `Other(String)` —
handle by renaming (`OtherMethod(String)` vs `OtherStatus(Int)`) or by
separating the types into their own modules per the "non-trivial API" rule
above.

**No circular imports:** Merging type B into module A means A's definition
includes B. If B references types from module C, then A imports C. Verify this
doesn't create a cycle (A → C → A).

## Worked examples

```
EncryptAlgorithm: AesCbc(iv:) | AesGcm(iv:) | RsaOaep | Other(String)
  Used only by subtle_crypto.encrypt / decrypt → keep in
  subtle_crypto.gleam.

KeyUsage: Encrypt | Decrypt | Sign | Verify | DeriveKey | DeriveBits |
  WrapKey | UnwrapKey
  Used by crypto_key, subtle_crypto, AND json_web_key (3 unrelated
  modules) → own module.

CompressionFormat: Deflate | DeflateRaw | Gzip | Brotli | Other(String)
  Shared across compression_stream + decompression_stream (sibling
  pair). → Lives in gossamer/compression.gleam (family parent);
  submodules import.

Method: Get | Post | Put | Delete | Other(String)
  In ecosystem (gleam_http) — lives with Scheme + other types in
  gleam/http.gleam. Same pattern.

IteratorResult: Yield(a) | Return(r)
  Used by iterator AND async_iterator (sibling but unrelated modules)
  → lives in family parent gossamer/iteration.gleam.

ReadResult: Value(a) | Done(Option(a))
  Used by readable_stream submodules. Circular-import constraint forces
  submodule placement.

StreamLifecycleError: Locked | Closed | Errored(reason:) |
  Aborted(reason:)
  Shared across 8 sibling submodules in the stream family. → Lives in
  gossamer/stream.gleam (family parent); submodules import.

CloseEvent: CloseEvent(code:, reason:, was_clean:)
  Used only by web_socket → keep in web_socket.gleam.

ArrayBuffer / Uint8Array
  Two sibling byte-buffer bindings with NO shared type. → Live as flat
  top-level modules (gossamer/array_buffer, gossamer/uint8_array), not
  under a buffer/ subdirectory.
```

## See also

- [Typed variants](./typed-variants.md) — naming variants within a module.
- [Builder patterns](./builder-patterns.md) — where builder records live.
- [Gleam's "Fragmented modules" anti-pattern](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/#fragmented-modules)
  — the official source.
