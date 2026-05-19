---
paths:
  - "src/**/*.gleam"
  - "src/**/*.ffi.ts"
  - "test/**/*.gleam"
---

# Throw Detection

LLM extension for `docs/contributing/throw-detection.md`. Read that contributor
doc first — it has the checklist, the reliable sources, Promise handling, the
verification process, typed error variants, and the no-clipping rationale. This
file adds process notes the human doc deliberately omits.

## Authoring new bindings

**Default bias: assume it throws.** Cheaper to wrap unnecessarily than to leak
an exception. Override only with positive evidence (no MDN Exceptions section,
no spec algorithm steps with "throw" or "reject").

**Distinguish input-driven from divergent.** If only one runtime throws and the
spec says it shouldn't, that's `runtime-divergence.md` territory — NOT this
rule.

## Typed-error phase discipline

When you're in the middle of a structural move (renaming a module, splitting a
type), define the shared error type during the move but adopt it across bindings
in a single follow-up commit. Don't conflate "reshape this module" with "convert
every binding's error type" — those are separate audits.

## Avoid inventing error causes

If you can't articulate a concrete throw condition, don't invent one just to
justify a `Result` wrap. Over-wrapping is a real cost. Re-read the spec and MDN;
if there's genuinely no throw path, return the raw type.

## Cross-references

- `runtime-divergence.md` — when a method throws on one runtime but not others
  (different rule).
- `doc-comments.md` — how to phrase the error doc comment on `Result`-returning
  bindings.
- `typed-variants.md` — how to name typed-error variants.
