# Conventions

A handful of patterns recur across gossamer's API. None are novel — they follow
established Gleam ecosystem idioms — but knowing the conventions makes the
binding catalog easier to navigate.

## Construction shapes

Configurable bindings take one of three shapes, picked by the argument profile
and what the underlying type allows:

- **Single function** — when every argument is essential (no defaults, no
  skippable options). Example: `subtle.encrypt(algorithm, key, data)`.
- **Record builder (`gleam_http` style)** — when the type is a Gleam record
  carrying stable, reusable identity. Setters use `set_<field>(record, field)`.
  Example: `fetch_extra.options() |> fetch_extra.set_cache(_)`.
- **Opaque builder (`glisten` / `mist` style)** — when the configured thing is
  an opaque JS reference with a mix of required and optional fields. A separate
  `Builder` record accumulates fields; a finalizer realizes it. Setters use
  `with_<field>(builder, field)`. Example:
  `web_socket.from_uri(uri) |> web_socket.with_on_event(handler) |> web_socket.build`.

See [`gleam_http`](https://hexdocs.pm/gleam_http/) for the canonical
record-builder precedent.

## Per-binding typed errors

`Result`-returning functions declare a typed error type specific to their
domain. Pattern match concrete variants rather than inspecting a generic dynamic
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
`InvalidAccessError`, `OperationError`, etc.) as named Gleam variants, each type
a closed set.

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
