# Builder patterns

How to model a binding that has construction options. Two patterns, chosen by
what the type's nature allows.

## The two patterns

### Pattern 1 — Type is a Gleam record (`gleam_http` style)

The type is a Gleam record carrying its full identity. Setters use
`set_<field>(record, value)` and return a modified record. Native conversion (if
any) happens at FFI boundaries when consumers send the record through.

Precedent:
[`gleam/http.Request`](https://hexdocs.pm/gleam_http/gleam/http/request.html),
[`gleam/http.Response`](https://hexdocs.pm/gleam_http/gleam/http/response.html),
[`wisp.Request`](https://hexdocs.pm/wisp/wisp.html#Request), and gossamer's own
`fetch_extra.FetchOptions`.

```gleam
pub type Foo {
  Foo(field_a: String, field_b: Bool)
}

pub fn new() -> Foo
pub fn set_field_a(foo: Foo, value: String) -> Foo
pub fn set_field_b(foo: Foo, value: Bool) -> Foo
```

### Pattern 2 — Builder for an opaque type (`glisten` style)

The configured thing is opaque (a JS reference, an actor, a server). A separate
Gleam-record `Builder` accumulates required and optional fields. Setters use
`with_<field>(builder, value)` and return a modified `Builder`. A finalizer (or
the consumer) realizes the `Builder` into the opaque thing.

Precedent: [`glisten.Builder`](https://hexdocs.pm/glisten/),
[`mist.Builder`](https://hexdocs.pm/mist/).

```gleam
pub type Foo  // opaque

pub type Builder {
  Builder(required_a: String, optional_b: Option(Bool))
}

pub fn new(required_a: String) -> Builder
pub fn with_optional_b(builder: Builder, value: Bool) -> Builder

pub fn build(builder: Builder) -> Foo
```

## When to use which

Apply Pattern 1 if the type satisfies all of these:

1. **No internal state.** Every observable property is captured by a field.
   There is nothing the JS engine holds onto across method calls that we can't
   put in the Gleam record.
2. **No imperative methods coupled to native dispatch.** No methods that must
   call native side effects synchronously and have those side effects observed
   by other native code.
3. **Construction options are also valid as ongoing fields.** The record's
   fields are stable identity, not just construction-time inputs.

If any condition fails, use Pattern 2.

### Common reasons Pattern 1 doesn't fit

- **Internal state.** `TextDecoder` carries multi-byte boundary state across
  `decode_chunk` calls. We can't extract that state into a Gleam-record field.
  Setters that "rebuild" would lose accumulated state.
- **Imperative methods coupled to native dispatch.** `WebSocket` has `send_*`
  and `close` methods that must reach the underlying JS socket synchronously. A
  pure Gleam record can't carry the live JS socket reference, and forcing every
  call site to thread state through the record would be a redesign of the
  imperative API. So `WebSocket` is opaque (Pattern 2): construction happens
  through a `Builder`, and the runtime API on the resulting `WebSocket`
  delegates to the JS object.

## Naming conventions

| Pattern                  | Setter prefix  | Constructor                                            |
| ------------------------ | -------------- | ------------------------------------------------------ |
| 1 (data record)          | `set_<field>`  | `new()` (or `from_<source>(x)` for typed alternatives) |
| 2 (`Builder` for opaque) | `with_<field>` | `new(required_args)`                                   |

The setter prefix difference is the visible signal: a reader sees `with_X` and
knows the chain produces a `Builder`; sees `set_X` and knows the type is the
data.

### Per-field setters

Both patterns expose **one setter per field**. Do not use a sum-type enum +
`List(Option)` constructor.

### Event-handler setters — `with_on_<event>` and `set_on_<event>`

Event-handler setters are explicit setters. Whether the target is a `Builder`
(Pattern 2) or an opaque object that mutates in place, the function name is a
`*_on_<event>` setter that makes the assignment explicit:

| Shape                                                 | Pattern           | Naming                                   |
| ----------------------------------------------------- | ----------------- | ---------------------------------------- |
| `Builder` setter for an event-handler field           | Pattern 2 builder | `with_on_<event>(builder, run handler:)` |
| Direct event-handler registration on an opaque object | n/a               | `set_on_<event>(target, run handler:)`   |

Plain configuration callbacks that aren't event handlers (stream
underlying-source/sink methods like `start`, `pull`, `cancel`, `write`,
`transform`, `flush`) keep the unprefixed `with_<field>` setter. The `_on_`
segment specifically marks the function as wiring up a JS-side `onevent` slot.

Gossamer-side examples:

- `abort_signal.set_on_abort(signal, run handler:)` — direct mutation.
- `message_port.set_on_message(port, run handler:)` — direct mutation.
- `web_socket.with_on_open(builder, run handler:)` — `Builder` setter.
- `readable_stream.with_pull(builder, run callback:)` — not an event handler;
  keeps unprefixed `with_<field>`.

## Reuse and inspectability

Pattern 1 produces standalone values that are easy to factor and share:

```gleam
let opts =
  fetch_extra.options() |> fetch_extra.set_cache(fetch_extra.CacheNoStore)
fetch_extra.send(req1, with: opts)
fetch_extra.send(req2, with: opts)
```

Pattern 2's `Builder` embeds required args and is single-use per realization:

```gleam
fn fatal(builder) {
  builder |> text_decoder.with_fatal(True)
}
let assert Ok(utf8) = text_decoder.new("utf-8") |> fatal |> text_decoder.build
let assert Ok(utf16) = text_decoder.new("utf-16") |> fatal |> text_decoder.build
```

When reusability across multiple invocations is a likely use case, Pattern 1 is
more natural. When the configured thing is one-shot (spawn a server, decode one
stream, open one socket), Pattern 2 fits.

## Module placement

A Pattern 1 record or Pattern 2 `Builder` usually lives in the same module as
its consumer. Single-consumer types do not earn their own module — see
[Module organization](./module-organization.md).

Only split into a separate module when the type is shared across two or more
unrelated top-level modules. Default to folding; split only with concrete
justification.

## Worked examples

### `File` — Pattern 1

```gleam
pub type File {
  File(
    blob: Blob,
    name: String,
    mime_type: String,
    last_modified: Timestamp,
  )
}

pub fn from_strings(parts: List(String), named name: String) -> File
pub fn from_blob(blob: Blob, named name: String) -> File
pub fn set_mime_type(file: File, value: String) -> File
pub fn set_last_modified(file: File, value: Timestamp) -> File
```

### `WebSocket` — Pattern 2 (construction) + opaque imperative (runtime)

```gleam
pub type WebSocket  // opaque
pub type Builder {
  Builder(
    url: String,
    protocols: List(String),
    binary_type: Option(BinaryType),
    on_open: Option(fn() -> Nil),
    on_message: Option(fn(Message) -> Nil),
    on_close: Option(fn(CloseEvent) -> Nil),
  )
}

pub fn from_url_string(url: String) -> Builder
pub fn with_protocols(builder: Builder, value: List(String)) -> Builder
pub fn with_on_message(
  builder: Builder,
  run handler: fn(Message) -> a,
) -> Builder

pub fn build(builder: Builder) -> Result(WebSocket, WebSocketError)

pub fn send_string(
  to socket: WebSocket,
  data data: String,
) -> Result(Nil, WebSocketError)
pub fn close(socket: WebSocket) -> Nil
```

### `TextDecoder` — Pattern 2

```gleam
pub type TextDecoder  // opaque (holds streaming state)
pub type Builder {
  Builder(label: String, fatal: Bool, ignore_bom: Bool)
}
pub fn new(label: String) -> Builder
pub fn with_fatal(builder: Builder, value: Bool) -> Builder
pub fn with_ignore_bom(builder: Builder, value: Bool) -> Builder
pub fn build(builder: Builder) -> Result(TextDecoder, DecoderError)

pub fn decode_chunk(
  decoder: TextDecoder,
  input: BitArray,
) -> Result(String, DecoderError)
```

### `fetch_extra.FetchOptions` — Pattern 1

```gleam
pub type FetchOptions {
  FetchOptions(
    cache: Option(Cache),
    signal: Option(AbortSignal),
    // ... other init-dict fields
  )
}

pub fn options() -> FetchOptions
pub fn set_cache(opts: FetchOptions, value: Cache) -> FetchOptions
pub fn set_signal(opts: FetchOptions, value: AbortSignal) -> FetchOptions

pub fn send(
  request: Request(String),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))
```

## See also

- [Module organization](./module-organization.md) — where a type's options live
  (single-consumer fold rule).
- [Typed variants](./typed-variants.md) — constructor naming (`new()` vs
  `from_<type>`).
- [Conventions](../conventions.md) — the user-facing summary of gossamer's API
  patterns.
- [Gleam's conventions, patterns, and anti-patterns](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/)
  — the general Gleam idioms gossamer's patterns build on.
