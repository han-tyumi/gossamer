---
paths:
  - "src/**/*.gleam"
  - "src/**/*.ffi.ts"
  - "src/**/*.type.ts"
  - "test/**/*.gleam"
---

# Builder Patterns

LLM extension for `docs/contributing/builder-patterns.md`. Read that contributor
doc first — it has the two patterns, the decision criteria, naming conventions,
and worked examples. This file adds process notes the human doc deliberately
omits.

## Authoring new bindings

When binding a new configurable JS type, walk the decision criteria from the
human doc against the spec / MDN — count "no" answers to the Pattern 1
conditions, default to Pattern 2 on any "no" or any throwing constructor.

The Pattern 1 trap: a public record lets users direct-construct invalid records,
forcing `Result` onto the primary operation. If the JS constructor throws, reach
for Pattern 2 so validation lives in `build`.

## Sanctioned exceptions

Don't introduce new ones without user approval.

- `web_socket.close_with(socket, code, reason)` — keeps the `_with` suffix
  because the bare `close(socket) -> Nil` returns no error, while `close_with`
  returns `Result(Nil, WebSocketError)` for code/reason validation. Collapsing
  into `close(socket, code, reason)` would force every default-close caller to
  unwrap.

## Cross-references

- `module-organization.md` — where a type's options live (single-consumer fold
  rule).
- `typed-variants.md` — constructor naming (`new()` vs `from_<type>`).
- `runtime-divergence.md` — Pattern 1 / Pattern 2 doc notes on builder setters
  when the JS field is missing on a runtime.
- `doc-comments.md` — `Builder` type doc shape; setter doc shape.
