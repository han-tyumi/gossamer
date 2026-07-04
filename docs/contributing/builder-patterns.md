# Builder patterns

How to model a binding that has construction options. Three shapes, chosen by
the argument profile and what the underlying type allows.

## The three shapes

### Single function — all arguments essential

The function takes every required argument (no defaults, no skippable options),
validates, and returns the constructed value (possibly wrapped in `Result`). No
intermediate `Builder` type.

```gleam
pub fn send(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))
```

Precedent: [`mist.websocket`](https://hexdocs.pm/mist/) (4 required callbacks),
[`gleam/fetch.send`](https://hexdocs.pm/gleam_fetch/) (1 required Request),
gossamer's `subtle.encrypt` / `subtle.sign` / `subtle.derive_bits` (all required
algorithm + key + data).

### Record builder — type is a Gleam record (`gleam_http` style)

The type is a Gleam record carrying its full identity. Setters use
`set_<field>(record, field)` and return a modified record. Native conversion (if
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
pub fn set_field_a(foo: Foo, field_a: String) -> Foo
pub fn set_field_b(foo: Foo, field_b: Bool) -> Foo
```

### Opaque builder — Builder for an opaque type (`glisten` style)

The configured thing is opaque (a JS reference, an actor, a server). A separate
Gleam-record `Builder` accumulates required and optional fields. Setters use
`with_<field>(builder, field)` and return a modified `Builder`. A finalizer
realizes the `Builder` into the opaque thing.

Precedent: [`glisten.Builder`](https://hexdocs.pm/glisten/),
[`mist.Builder`](https://hexdocs.pm/mist/).

```gleam
pub type Foo  // opaque

pub opaque type Builder {
  Builder(required_a: String, optional_b: Option(Bool))
}

pub fn new(required_a: String) -> Builder
pub fn with_optional_b(builder: Builder, optional_b: Bool) -> Builder

pub fn build(builder: Builder) -> Foo
```

## Decision tree

Walk top-down. Stop at the first match.

1. **All arguments essential** (every caller must provide every argument, no
   defaults make sense)? Use a **single function**. Examples:
   `subtle.encrypt(algorithm, key, data)`, `subtle.sign(algorithm, key, data)`,
   `gleam/fetch.send(request)`.
2. **Type is a plain Gleam record carrying stable identity**, observable
   properties all captured as fields, reusable across calls? Use a **record
   builder**. `fetch_extra.FetchOptions` is the canonical example — many config
   options, reused across multiple `send` calls.
3. **Mix of required and optional arguments, underlying thing is opaque** (holds
   JS state, has imperative methods, can't be a plain record)? Use an **opaque
   builder**. `TextDecoder`, `WebSocket`, `Worker`, and the Intl formatters all
   fit here.

### Why "all essential" is the trigger for single function

A single function makes every caller spell out every argument. When all
arguments are essential, that's the right contract — there are no "common
defaults" to opt out of. `mist.websocket(request, handler, on_init, on_close)`
works because no caller can sensibly skip any of those.

When even one argument is optional with a sensible default, the opaque builder
wins: callers who want the default just don't call the setter. A single function
would force them to spell out the default value at every call site.

`web_socket` has `protocols` (default `[]`) and `on_event` (often set, but
distinct from the connection itself) — opaque builder lets you skip `protocols`
when you don't need it. `worker` has `name` (rarely set) and `on_message` (often
skipped) — same logic.

### Common reasons the record builder doesn't fit

- **Internal state.** `TextDecoder` carries multi-byte boundary state across
  `decode_chunk` calls. We can't extract that state into a Gleam-record field.
  Setters that "rebuild" would lose accumulated state.
- **Imperative methods coupled to native dispatch.** `WebSocket` has `send_*`
  and `close` methods that must reach the underlying JS socket synchronously. A
  pure Gleam record can't carry the live JS socket reference.

## Naming conventions

| Shape           | Setter prefix  | Constructor                                            |
| --------------- | -------------- | ------------------------------------------------------ |
| Single function | (no setters)   | Domain verb (`send`, `encrypt`) or `from_<type>`       |
| Record builder  | `set_<field>`  | `new()` (or `from_<source>(x)` for typed alternatives) |
| Opaque builder  | `with_<field>` | `new(required_args)` or `from_<type>(typed_input)`     |

The setter prefix difference is the visible signal: a reader sees `with_X` and
knows the chain produces a `Builder`; sees `set_X` and knows the type is the
data; sees no setters and knows the constructor takes everything at once.

### Per-field setters

Both the record builder and the opaque builder expose **one setter per field**.
Do not use a variant type plus a `List(Option)` constructor.

### Setter parameter names

Setters use semantic parameter names matching the field they set (gleam_http
precedent): `set_method(req, method:)`, `set_host(req, host:)`,
`with_protocols(builder, protocols:)`. Generic `value:` is avoided.

### Event-handler setters — `with_on_<event>` and `set_on_<event>`

Event-handler setters use an `on_<event>` segment. Whether the target is a
`Builder` (opaque-builder shape) or an opaque object that mutates in place, the
name makes the assignment explicit:

| Site                                                  | Shape          | Naming                              |
| ----------------------------------------------------- | -------------- | ----------------------------------- |
| `Builder` setter for an event-handler field           | Opaque builder | `with_on_<event>(builder, handler)` |
| Direct event-handler registration on an opaque object | n/a            | `set_on_<event>(target, handler)`   |

The callback is passed positionally — no label. Tier-1 libraries pass handlers
and effects positionally (`mist`, `lustre`), so a generic `run`/`with` label on
the callback adds nothing.

Plain configuration callbacks that aren't event handlers (stream
underlying-source/sink methods like `start`, `pull`, `cancel`, `write`,
`transform`, `flush`) keep the unprefixed `with_<field>` setter and name the
callback parameter for the role it fills (`lustre` names its lifecycle pieces
`init`/`update`/`view` the same way). The `_on_` segment specifically marks the
function as wiring up a JS-side `onevent` slot.

Gossamer-side examples:

- `message_port.set_on_message(port, handler)` — direct mutation.
- `web_socket.with_on_event(builder, handler)` — `Builder` setter; the handler
  receives the `WebSocket` so it can reply via `send_*`.
- `worker.with_on_message(builder, handler)` — `Builder` setter; the handler
  also receives the `Worker` so it can reply via `post_message`.
- `readable_stream.with_pull(builder, pull)` — not an event handler; keeps the
  unprefixed `with_<field>` setter with a role-named parameter.

Single-shot async events (where the event fires at most once) use a
`Promise`-returning observer rather than a setter — see
`abort_signal.on_abort(signal) -> Promise(AbortReason)`.

## Reuse and inspectability

The record builder produces standalone values that are easy to factor and share:

```gleam
let opts =
  fetch_extra.options() |> fetch_extra.set_cache(fetch_extra.CacheNoStore)
fetch_extra.send(req1, with: opts)
fetch_extra.send(req2, with: opts)
```

The opaque builder embeds required args and is single-use per realization:

```gleam
fn fatal(builder) {
  builder |> text_decoder.with_fatal(True)
}
let assert Ok(utf8) = text_decoder.new("utf-8") |> fatal |> text_decoder.build
let assert Ok(utf16) = text_decoder.new("utf-16") |> fatal |> text_decoder.build
```

A single-function constructor is one-shot by definition — no intermediate value
to reuse or extend.

When reusability across multiple invocations is likely, the record builder fits
best. When the configured thing is one-shot (spawn a server, decode one stream,
open one socket), the opaque builder fits.

## Module placement

A record builder or opaque `Builder` usually lives in the same module as its
consumer. Single-consumer types do not earn their own module — see
[Module organization](./module-organization.md).

Only split into a separate module when the type is shared across two or more
unrelated top-level modules. Default to folding; split only with concrete
justification.

## Worked examples

### `subtle.encrypt` — single function

All three arguments are essential: every caller must pick an algorithm, supply a
key, and provide data. No defaults make sense.

```gleam
pub fn encrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))
```

### `WebSocket` — opaque builder

One required `uri` plus optional `protocols` (often `[]`) and `on_event` (often
set, but skippable for fire-and-forget). The opaque builder lets callers skip
the setters they don't need.

```gleam
pub type WebSocket  // opaque

pub fn new(uri: Uri) -> Builder
pub fn with_protocols(builder: Builder, protocols: List(String)) -> Builder
pub fn with_on_event(
  builder: Builder,
  handler: fn(WebSocketEvent, WebSocket) -> a,
) -> Builder
pub fn build(builder: Builder) -> Result(WebSocket, WebSocketError)

pub fn send_text(
  to socket: WebSocket,
  data data: String,
) -> Result(Nil, WebSocketError)
pub fn close(socket: WebSocket) -> Nil
```

The `with_on_event` handler also receives the `WebSocket` so it can call
`send_*` from inside while pattern-matching on the `WebSocketEvent`. Handler
argument order is data-first, self-last (`fn(event, socket)`) to match the
`mist.websocket` / `glisten` convention.

### `File` — record builder

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
pub fn set_mime_type(file: File, mime_type: String) -> File
pub fn set_last_modified(file: File, last_modified: Timestamp) -> File
```

### `TextDecoder` — opaque builder

Multi-byte boundary state across `decode_chunk` calls forces opaqueness.

```gleam
pub type TextDecoder  // opaque (holds streaming state)
pub type Builder {
  Builder(label: String, fatal: Bool, ignore_bom: Bool)
}
pub fn new(label: String) -> Builder
pub fn with_fatal(builder: Builder, fatal: Bool) -> Builder
pub fn with_ignore_bom(builder: Builder, ignore_bom: Bool) -> Builder
pub fn build(builder: Builder) -> Result(TextDecoder, DecoderError)

pub fn decode_chunk(
  decoder: TextDecoder,
  input: BitArray,
) -> Result(String, DecoderError)
```

### `fetch_extra.FetchOptions` — record builder

Many config fields, all optional, reused across multiple `send` calls. The
configuration is data — no opaque underlying state.

```gleam
pub type FetchOptions {
  FetchOptions(
    cache: Option(Cache),
    signal: Option(AbortSignal),
    // other fields...
  )
}

pub fn options() -> FetchOptions
pub fn set_cache(opts: FetchOptions, cache: Cache) -> FetchOptions
pub fn set_signal(opts: FetchOptions, signal: AbortSignal) -> FetchOptions

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
- [Gleam's conventions, patterns, and anti-patterns](https://gleam.run/documentation/conventions-patterns-and-anti-patterns/)
  — the general Gleam idioms gossamer's patterns build on.
