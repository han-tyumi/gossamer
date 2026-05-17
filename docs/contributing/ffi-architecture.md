# FFI architecture

How gossamer wires Gleam to JavaScript across the Foreign Function Interface
boundary, and what each piece of the build pipeline does.

## FFI pattern

```
Gleam (.gleam)  →  FFI TypeScript (.ffi.ts)  →  Bundled JS (.ffi.mjs)  →  Web APIs
```

Each API module has two parts:

1. **Gleam declarations** define types and function signatures with `@external`
   annotations.
2. **FFI implementations** (`.ffi.ts`) contain the TypeScript that calls the Web
   APIs.

Example — `src/gossamer/abort_signal.gleam`:

```gleam
@external(javascript, "./abort_signal.ffi.mjs", "abort")
pub fn abort(reason: r) -> AbortSignal
```

Corresponding `src/gossamer/abort_signal.ffi.ts`:

```typescript
export const abort: typeof $abortSignal.abort = (reason) => {
  return AbortSignal.abort(reason);
};
```

## External type annotations

Opaque types that wrap JS types use separate `.type.ts` files for the type
alias. This ensures consumers who install via hex get type files that resolve
correctly without needing `$/` or `~/` import aliases.

```typescript
// In abort_signal.type.ts
export type AbortSignal$ = AbortSignal;
```

```gleam
// In abort_signal.gleam
@external(javascript, "./abort_signal.type.ts", "AbortSignal$")
pub type AbortSignal
```

The `.ffi.ts` file contains the full implementation (for dev-time type
checking), while the `.type.ts` file contains only the type export (for
consumers).

Types use a `$` suffix (Gleam's convention) to avoid naming conflicts with JS
globals.

## Build process

The `build.ts` script uses esbuild to:

1. Find all `.ffi.ts` files in `src/`.
2. Bundle each with dependencies (one esbuild call per entry point).
3. Output colocated `.ffi.mjs` files alongside their `.ffi.ts` sources.

The `buildImportMapper` plugin resolves `$/` imports to correct relative paths
from each file's build output location.

## Build workarounds

- `patch/` overrides Gleam-generated `gleam.d.mts` files that have duplicate
  exports (Gleam compiler issue with `prelude.mjs` + `prelude.d.mts`
  re-exports).
- `prelude.d.ts` is module augmentation that bridges `$/prelude.mjs` to
  `$/prelude.d.mts` for correct generic type resolution.

## Import aliases in FFI files

- `$/` — references built Gleam output (`build/dev/javascript/`).
- `~/` — references local `src/` directory.

These aliases are only for development. The `.type.ts` files shipped to
consumers have no aliases — they contain only self-contained type exports.

## Gleam stable API

FFI code uses Gleam's stable constructor API instead of internal class
constructors:

- `Option$None()`, `Option$Some(value)` instead of `new None()`,
  `new Some(value)`.
- `Result$Ok(value)`, `Result$Error(value)` instead of `new Ok(value)`,
  `new Error(value)`.

## Utilities

`src/utils/` contains helpers for Gleam/JavaScript type conversions:

- `option.ts` — Convert nullish values to Gleam `Option`.
- `result.ts` — Convert `try` / `catch` to Gleam `Result`.
- `dict.ts` — `Dict` to JS object conversions.
- `list.ts` — `List` / `Array` conversions (`fromArray`, `fromArrayMapped`,
  `toArray`).

## Module layout

- `src/gossamer.gleam` — Top-level Web APIs (`fetch`, timers, `alert` /
  `confirm` / `prompt`).
- `src/gossamer/` — Web API submodules (`promise`, `url`, `headers`, streams,
  crypto, etc.).

See [Module organization](./module-organization.md) for rules on which types
share a module and which get their own.

## Cross-runtime compatibility

All code must work across Deno, Node.js, Bun, and browsers. No runtime-specific
APIs (e.g., `Deno.*`, `process.*`). Use `globalThis` for global access. Run
`just test` to verify across Deno, Node.js, and Bun.

## See also

- [API mapping](./api-mapping.md) — how JS surfaces translate to Gleam.
- [Throw detection](./throw-detection.md) — where the FFI wraps thrown errors.
- [Runtime gaps](../runtime-gaps.md) — known cross-runtime divergences.
