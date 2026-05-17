# API mapping

How JavaScript surfaces map to Gleam in gossamer. Detail-level reference for
binding authors. The user-facing summary lives in
[Conventions](../conventions.md).

## Constructors

| JS pattern              | Gleam pattern                           | Example                               |
| ----------------------- | --------------------------------------- | ------------------------------------- |
| `new Foo()`             | `foo.new()`                             | `headers.new()`                       |
| `new Foo(arg)`          | `foo.new(arg)`                          | `text_decoder.new(label)`             |
| `new Foo(arg, options)` | `foo.new(arg) \|> foo.set_<field>(...)` | `response.new(200) \|> set_body(...)` |
| `Foo.from(x)`           | `foo.from_<type>(value)`                | `uint8_array.from_list(…)`            |

See [Typed variants](./typed-variants.md) for the full constructor-naming
catalog.

## Read-only properties (getters)

| JS pattern               | Gleam pattern              | Example                       |
| ------------------------ | -------------------------- | ----------------------------- |
| `obj.prop` (non-boolean) | `module.prop(obj)`         | `response.status(resp)`       |
| `obj.ok` (boolean)       | `module.is_ok(obj)`        | `response.is_ok(resp)`        |
| `obj.locked` (boolean)   | `module.is_locked(obj)`    | `stream.is_locked(stream)`    |
| `obj.bodyUsed` (boolean) | `module.is_body_used(obj)` | `response.is_body_used(resp)` |

Boolean properties always get the `is_` prefix. Non-boolean properties use the
property name directly. Subject is always the first argument.

## Mutable properties (getter + setter)

| JS pattern           | Gleam pattern                  | Example       |
| -------------------- | ------------------------------ | ------------- |
| `url.hostname` (get) | `url.hostname(url)`            | Direct name   |
| `url.hostname = "x"` | `url.set_hostname(url, value)` | `set_` prefix |

FFI bindings present pure-functional semantics on the Gleam side, even when the
underlying JS object is mutable (`URL`, `Headers`, `FormData`, etc.). The FFI
clones the JS object before mutating, returning the clone — matching
`gleam_fetch/form_data`'s pattern.

## Instance methods

| JS pattern                  | Gleam pattern                  | Example                     |
| --------------------------- | ------------------------------ | --------------------------- |
| `headers.append(name, val)` | `headers.append(h, name, val)` | Subject first               |
| `response.clone()`          | `response.clone(resp)`         | No-arg methods become 1-arg |
| `promise.then(fn)`          | `promise.then(p, fn)`          | Web-faithful name           |

Instance methods become module functions with the subject as the first argument.
Use the Web API method name, `snake_cased`.

## Static methods

| JS pattern             | Gleam pattern          | Example      |
| ---------------------- | ---------------------- | ------------ |
| `Promise.all(list)`    | `promise.all(list)`    | Direct name  |
| `Promise.resolve(val)` | `promise.resolve(val)` | Direct name  |
| `URL.canParse(str)`    | `url.can_parse(str)`   | `snake_case` |

Static methods become module functions. No subject argument.

## Reserved words

| JS name   | Gleam function | FFI export |
| --------- | -------------- | ---------- |
| `type`    | `type_()`      | `type_`    |
| `catch`   | `catch()`      | `catch_`   |
| `finally` | `finally()`    | `finally_` |

The Gleam function uses `_` suffix only when the name is a Gleam reserved word.
The FFI export always uses `_` suffix for these.

## Overloaded methods and optional parameters

The ecosystem default is **one function with all params required.** No
`_with_<name>` variants for optional extension.

| JS pattern            | Gleam pattern                      | Notes                                |
| --------------------- | ---------------------------------- | ------------------------------------ |
| `slice(start)`        | `slice(obj, start)`                | Base version                         |
| `slice(start, end)`   | `slice(obj, from: start, to: end)` | Single function, positional-required |
| `close()`             | `close(obj)`                       | Base version                         |
| `close(code, reason)` | Builder OR positional-required     | Per binding                          |

For configuration overloads, use the builder pattern (see
[Builder patterns](./builder-patterns.md)). For mandatory positional overloads,
prefer positional-required with sensible defaults (`[]` for empty list, etc.).
When a base `verb -> Nil` would regress to `verb -> Result` on collapse, keep
the `verb` + `verb_with(extra)` pair as a sanctioned exception — currently only
`web_socket.close` and `close_with`.

## Options and configuration

No `*Init` enum types. No options-list parameters. JS options objects
(`RequestInit`, `ResponseInit`, `EventInit`, `TextDecoderOption`, etc.) are
replaced by the builder pattern. See [Builder patterns](./builder-patterns.md).

## Enum-like string parameters

Well-defined string enums become Gleam variant types in their own module (see
[Module organization](./module-organization.md)).

```gleam
pub type CompressionFormat {
  Deflate
  DeflateRaw
  Gzip
  Brotli
  Other(String)
}

compression.Gzip
```

Open-ended string values stay as `String`.

## Callbacks and events

Event-handler setters are explicit setters:

| JS pattern                | Gleam pattern                                                  | Form              |
| ------------------------- | -------------------------------------------------------------- | ----------------- |
| `new WS(...)` then config | `web_socket.from_url_string(url) \|> with_on_message(handler)` | Pattern 2 builder |
| `signal.onabort = fn`     | `abort_signal.set_on_abort(signal, handler)`                   | Direct on opaque  |
| `port.onmessage = fn`     | `message_port.set_on_message(port, handler)`                   | Direct on opaque  |

The `_on_<event>` segment marks the function as wiring up a JS-side `onevent`
slot. Plain configuration callbacks that aren't event handlers (stream `start`,
`pull`, `cancel`, `write`, `transform`, `flush`) keep the unprefixed
`with_<field>` `Builder` setter.

Callback parameters are always last (for `use` syntax compatibility).

## Error handling

| JS behavior             | Gleam return type                 | Example                                             |
| ----------------------- | --------------------------------- | --------------------------------------------------- |
| Returns value           | Direct return                     | `url.hostname(url) -> String`                       |
| Returns nullable        | `Result(a, Nil)`                  | `headers.get(h, name) -> Result(…)`                 |
| Optional param / field  | `Option(a)`                       | `fn(Option(next))`, `Done(Option(a))`               |
| Throws (input-driven)   | `Result(a, ModuleError)`          | `url.new(href) -> Result(Uri, UrlError)`            |
| Promise resolves (safe) | `Promise(a)`                      | Can't reject by design                              |
| Promise can reject      | `Promise(Result(a, ModuleError))` | `response.text(r) -> Promise(Result(_, BodyError))` |

Per-binding typed error sums. See [Throw detection](./throw-detection.md).

## Gleam-friendly helpers (additive)

Helpers that bridge Gleam types are additive alongside the spec-faithful API:

| Pattern                | Naming          | Example                         |
| ---------------------- | --------------- | ------------------------------- |
| Convert to Gleam type  | `to_list`, etc. | `headers.to_list(h) -> List(…)` |
| Bridge from Gleam type | `from_result`   | `promise.from_result(result)`   |

## See also

- [Builder patterns](./builder-patterns.md)
- [Typed variants](./typed-variants.md)
- [Module organization](./module-organization.md)
- [Throw detection](./throw-detection.md)
- [Labels](./labels.md)
- [Doc comments](./doc-comments.md)
- [FFI architecture](./ffi-architecture.md)
