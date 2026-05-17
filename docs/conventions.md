# Conventions

A handful of patterns recur across gossamer's API. None are novel — they follow
established Gleam ecosystem idioms — but knowing the conventions makes the
binding catalog easier to navigate.

## Builder pattern over options lists

Configurable types use chained setters rather than a `List(SomeOption)`
constructor argument:

```gleam
let request =
  request.new()
  |> request.set_method(http.Post)
  |> request.set_header("content-type", "application/json")
  |> request.set_body(json_payload)
```

Two flavors, named for the Gleam ecosystem precedent:

- **Record builders (`gleam_http` style)** — the type IS a Gleam record. Setters
  use `set_<field>(record, value)`. Example: `fetch_extra.options()` /
  `set_cache` / `set_signal`.
- **Opaque builders (`glisten` / `mist` style)** — the configured thing is an
  opaque JS reference; a separate `Builder` record accumulates required and
  optional fields, then a finalizer realises it. Setters use
  `with_<field>(builder, value)`. Example: `text_decoder.new(label)` /
  `with_fatal` / `build`.

See [`gleam_http`](https://hexdocs.pm/gleam_http/) for the canonical
record-builder precedent.

## Per-binding typed errors

`Result`-returning functions declare a typed error sum specific to their domain.
Pattern match concrete variants rather than inspecting a generic dynamic
payload:

```gleam
case subtle.derive_bits(algorithm, key, length) {
  Ok(bits) -> use_bits(bits)
  Error(crypto.AlgorithmNotSupported) -> fall_back()
  Error(crypto.InvalidAccess) -> abort()
  Error(_) -> log_and_continue()
}
```

The variants mirror the JS spec's failure modes (`NotSupportedError`,
`InvalidAccessError`, `OperationError`, etc.) wrapped as Gleam constructors,
each one a closed sum.

This follows
[`gleam/fetch.FetchError`](https://hexdocs.pm/gleam_fetch/gleam/fetch.html#FetchError)
and aligns with the
[Gleam conventions doc](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/#design-descriptive-errors)
on descriptive errors.

## Transit types for JS interop

A few bindings (`Uint8Array`, `ArrayBuffer`, `Map`, `Set`, `Iterator`,
`AsyncIterator`) are exposed as JS-native types because some Web APIs return
them and consumers occasionally need to send them through to other JS code.
They're **transit types** — for crossing the boundary, not for working on
directly.

Prefer the canonical Gleam type when you control the data flow:

| JS-native (transit)          | Canonical Gleam                                                    |
| ---------------------------- | ------------------------------------------------------------------ |
| `Uint8Array` / `ArrayBuffer` | [`BitArray`](https://hexdocs.pm/gleam_stdlib/gleam/bit_array.html) |
| `Map`                        | [`gleam/dict`](https://hexdocs.pm/gleam_stdlib/gleam/dict.html)    |
| `Set`                        | [`gleam/set`](https://hexdocs.pm/gleam_stdlib/gleam/set.html)      |
| `Iterator`                   | [`gleam_yielder.Yielder`](https://hexdocs.pm/gleam_yielder/)       |
| `AsyncIterator`              | (no Gleam counterpart; consume via the binding's helpers)          |

Each transit binding ships `from_*` / `to_*` bridges
(`uint8_array.to_bit_array`, `map.from_dict`, etc.) so crossing the boundary is
one function call. The canonical Gleam type stays the default for everything
inside your code; reach for the transit type only when a JS API forces you to.

## Pure-functional API

The public Gleam API is pure-functional. Setters return new values; the
underlying JS objects (`URL`, `Headers`, `FormData`, etc.) are cloned at the FFI
boundary when mutation would otherwise be observable. Gleam code sees value
semantics:

```gleam
let headers_a = headers.new() |> headers.set("x-foo", "1")
let headers_b = headers_a |> headers.set("x-foo", "2")
// headers_a is unchanged; headers_b is the new value
```

This costs one clone per setter, traded for the consistency of treating gossamer
bindings like any other Gleam value. If you specifically need mutation semantics
for performance reasons, you can drop down to a custom FFI — but the public
Gleam API will never expose observable mutation.

## See also

- [Runtime gaps](./runtime-gaps.html) — known cross-runtime divergences in the
  bindings.
- [Coverage](./coverage.html) — what gossamer wraps and what it delegates to
  ecosystem packages.
- [Gleam's official conventions, patterns, and anti-patterns](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/)
  — the general Gleam idioms gossamer's patterns build on.
