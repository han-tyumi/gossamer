---
paths:
  - "src/**/*.gleam"
  - "src/**/*.ffi.ts"
  - "src/**/*.type.ts"
  - "test/**/*.gleam"
---

# Typed Variants

LLM extension for `docs/contributing/typed-variants.md`. Read that contributor
doc first — it has the "expose a variant" criteria, the ecosystem-observed
patterns table, the constructor and operation naming, what gossamer doesn't do,
and worked examples. This file adds process notes the human doc deliberately
omits.

## Authoring new bindings

**Reject the `_with_<name>` reflex.** If your first instinct is `slice_with_end`
or `new_with_base`, stop — the ecosystem doesn't use that pattern. Either make
the param required (the default) or pick a concrete suffix from the ecosystem
table.

When the JS API takes `number | bigint`, bind separate Gleam functions per type:
`format_float` / `format_int` / `format_big_int`. No bare-name preference for
`Float`. Gleam's type system can't union `number` and `bigint` ergonomically.

When the JS API has positional overloads, resolve to one function with all
params required — unless either:

- The bare and variant have different `Result`-ness — see `web_socket.close` /
  `close_with` sanctioned exception.
- The variant is constructed via a `Builder` — defer to `builder-patterns.md`.

## Cross-references

- `builder-patterns.md` — `with_<field>` on a `Builder` is a distinct concept;
  setter names follow a separate rule.
- `module-organization.md` — where typed variants live (single-consumer fold
  rule).
- `doc-comments.md` — how to phrase variant doc comments ("`from_X` constructs
  from an X" — terse).
