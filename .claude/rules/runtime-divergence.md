---
paths:
  - "src/**/*.gleam"
  - "src/**/*.ffi.ts"
  - "test/**/*.gleam"
---

# Runtime Divergence

Companion rule for the contributor-facing
[Handling runtime divergence](../../CONTRIBUTING.md#handling-runtime-divergence)
section in `CONTRIBUTING.md`. Read that section first — it has the policy, the
decision tree, and the two patterns (Pattern 1 spec-default-at-FFI vs Pattern 2
diagnostic-FFI-throw). This file adds process notes the human doc deliberately
omits.

`docs/runtime-gaps.md` is the published catalog of known gaps. Every new gap
handled under this rule must land an entry there.

## When the rule applies

Apply when a Web API behaves differently across runtimes:

- A getter returns `undefined` on one runtime where the spec defines a value.
- A method doesn't exist on one runtime where the spec defines it.
- A method silently clips/clamps on one runtime where the spec throws.

Does **not** apply to spec-defined throws on all runtimes — those go to
`throw-detection.md` and get wrapped in `Result`.

## Sanctioned-exception note

The Gleam conventions doc says "Libraries must not panic, so they should not use
`panic` or `let assert`." Pattern 2 is an FFI-side `throw new Error(...)` —
**not** a Gleam-side `panic` or `let assert`. The native runtime error would
already throw at the same call site if we did nothing; the diagnostic message is
strictly an improvement.

Always document the panic condition on the Gleam binding (per the "Documenting
the divergence" section of `CONTRIBUTING.md`) so users on the divergent runtime
know the call may throw.

## Cross-references

- `throw-detection.md` — spec throws (input-driven, recoverable failures).
  Result-wrap. Different domain from this rule.
- `module-organization.md` — where divergent bindings live.
- `doc-comments.md` — how to phrase the doc note on the Gleam binding.
