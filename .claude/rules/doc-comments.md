---
paths:
  - "src/**/*.gleam"
---

# Doc Comments

LLM extension for `docs/contributing/doc-comments.md`. Read that contributor doc
first — it has the style guide: placement, voice, backticks, spacing, error
prose, examples, cross-references, callouts, type-level docs, module-level docs,
sourcing, JavaScript framing, what to skip, and applied examples. This file adds
process notes the human doc deliberately omits.

## Don't fabricate error causes

If you can't articulate a concrete error trigger but the function is
`Result`-returning, the function may be over-wrapped — investigate per
`throw-detection.md`. Don't write "Returns an error if JavaScript decides this
is invalid" — that's a signal you don't know the cause yet.

## Don't leak JS values into Gleam-side prose

Document JS behavior when relevant (`JSON.stringify` throws on cycles). Don't
describe Gleam-side return values using JS value names:

- ✗ "Returns `undefined` if the key is missing."
- ✓ "Returns `Error(Nil)` if the key is missing."

The Gleam side has its own answer.

## Audit before doc-writing

Before doc'ing a module, audit `Result` wraps against the spec. Unwrap
over-wraps first. Documenting a fabricated error cause locks in the over-wrap
and creates downstream coordination cost.

## Cross-references

- `throw-detection.md` — when to wrap throws in `Result` (informs error prose).
- `runtime-divergence.md` — Pattern 1 / Pattern 2 doc notes for runtime gaps.
- `module-organization.md` — anchor vs satellite module placement (informs type
  doc strategy).
- `builder-patterns.md` — builder doc shape (informs which functions point at
  `[`build`](#build)`).
- `typed-variants.md` — constructor naming (informs cross-reference prose).
