# Typed variants

When a function could accept multiple related input types, or describe a
related-but-distinct operation, decide whether to expose multiple variants or
one canonical signature, and pick a name that matches what the Gleam ecosystem
actually does.

## When to expose a variant

Expose a variant only if:

1. The input type is **fundamentally incompatible** with existing variants —
   e.g., `Yielder` and `AsyncIterator` are different Gleam types that can't be
   union'd.
2. OR it's a **common operation** where requiring the user to chain conversions
   would be meaningfully verbose.
3. OR the variation has a concrete, nameable semantic difference (directional,
   predicate-based, format-specific, etc.) that a single function can't
   naturally express.

Otherwise, default to **one function with all params required**. Users chain via
`list |> iterator.from_list |> readable_stream.from_iterator`. `gleam_stdlib`'s
`string.slice(from, at_index, length)` takes three required params rather than
splitting into `slice` + `slice_with_length`.

The ecosystem default is: **one function with all params required.** Variants
exist when the variation has its own name.

## Ecosystem-observed variant patterns

Cross-referenced from `gleam_stdlib`, `gleam_time`, `gleam_http`, `gleam_fetch`,
`gleam_javascript`, `gleam_json`, `lustre`, `mist`, `glisten`, `plinth`, and
`wisp`. Every pattern below appears at least twice across those packages.

| Pattern                                                      | Purpose                        | Ecosystem examples                                                                                 |
| ------------------------------------------------------------ | ------------------------------ | -------------------------------------------------------------------------------------------------- |
| `from_<type>(x)`, `to_<type>(x)`                             | Typed I/O                      | `bit_array.from_string`, `list.to_dict`                                                            |
| `from_<format>`, `to_<format>`, `parse_<format>`             | Format-specific I/O            | `timestamp.to_iso8601_string`, `timestamp.parse_rfc3339`, `lustre.element.to_document_string_tree` |
| `_start` / `_end`, `_first` / `_last`, `_prefix` / `_suffix` | Directional pairs              | `string.drop_start` / `drop_end`, `string.starts_with` / `ends_with`, `list.first` / `last`        |
| `_while`, `_until`, `_once`                                  | Predicate / count-limited      | `list.take_while`, `list.fold_until`, `string.split_once`                                          |
| `_at`, `_at_index`                                           | Positional                     | `list.optionally_at`, `array.with(at_index:)`                                                      |
| `_by_<criterion>`                                            | Criterion variant              | `performance.get_entries_by_name`, `list.sort(by:)`                                                |
| `_and_<param>`                                               | Additional precision component | `timestamp.from_unix_seconds_and_nanoseconds`                                                      |
| `_<output_kind>`                                             | Output flavor suffix           | `lustre.element.to_string_tree`                                                                    |
| `key_*`, `try_*`, `index_*`, `base64_*` (prefix)             | Kind-tailored variant          | `list.try_each`, `list.key_filter`, `list.index_fold`                                              |
| `with_<field>` on `Builder`                                  | Builder setters only           | `mist.with_tls`, `glisten.with_pool_size`                                                          |
| `set_<field>` on data record                                 | Data-record setters            | `gleam_http.set_body`, `gleam_http.set_header`                                                     |
| `is_<predicate>`, `is_valid_<thing>`                         | Predicates                     | `bit_array.is_utf8`, `time.is_valid_date`                                                          |

The unifying principle: **every variant suffix or prefix concretely names what
differs.** Generic `_with_<name>` for "this variant takes an additional `<name>`
parameter" is not a pattern the ecosystem uses.

## Constructors — `new` and `from_<type>`

| Form                             | Name                      | Example                                                                                         |
| -------------------------------- | ------------------------- | ----------------------------------------------------------------------------------------------- |
| Empty (zero-arg)                 | `new()`                   | `blob.new()`, `form_data.new()`, `dict.new()`                                                   |
| Single primary arg               | `new(x)`                  | `array_buffer.new(byte_length)` (returns anchor), `text_decoder.new(label)` (returns `Builder`) |
| Multiple typed data alternatives | `from_<type>(x)` for each | `blob.from_string`, `blob.from_bytes`, `blob.from_blob`                                         |
| Format-specific construction     | `from_<format>(x)`        | `uint8_array.from_base64`-style spec helpers                                                    |

`new` and `from_<type>` are **not mutually exclusive**. `new()` handles the
empty case; `from_<type>` handles each kind of data. A module can have both —
`blob.new()` (empty) plus `blob.from_string` / `blob.from_bytes` /
`blob.from_blob`.

The choice between `new(x)` and `from_<type>(x)` is: use `new(x)` when there's
one sensible single-arg constructor; use `from_<type>(x)` when multiple typed
data alternatives exist.

## Operations — verb-like functions

When the same conceptual operation has variants, name each by what makes it
different from the base.

### Typed-input variants

```gleam
web_socket.send_text(socket, data: String)
web_socket.send_binary(socket, data: BitArray)
web_socket.send_blob(socket, data: Blob)
```

Each `_<type>` suffix names the input that differs. The base form either accepts
the default type or doesn't exist, in which case every variant is `verb_<type>`
(as above — no `send` without a type suffix).

```gleam
form_data.append(form_data, name, value: String)
form_data.append_bits(form_data, name, value: BitArray)
form_data_extra.append_file(form_data, name, value: File)
```

Here `form_data.append` is the base `String` form (in `gleam_fetch`), and
`append_bits` / `append_file` are typed variants — `append_file` lives in
gossamer's `form_data_extra` because `File` isn't covered upstream.

### Directional, positional, or predicate variants

Pick the concrete suffix from the ecosystem table above.

```gleam
string.drop_start(string, num_graphemes)
string.drop_end(string, num_graphemes)
list.take_while(list, predicate)
list.fold_until(list, initial, fun)
list.optionally_at(list, index)
```

### Range parameters

When an operation takes start, end, or length offsets, use `_from`, `_to`,
`_range`, or `_within` suffixes — not `_with_start` or `_with_end`.

```gleam
uint8_array.from_buffer_range(buffer, byte_offset:, length:)
```

Read as English: "slice from (start) to (end)" parses better than
"slice_with_start" / "slice_with_end".

### Criterion variants

When the variation picks an attribute of the subject:

```gleam
performance.get_entries(...)
performance.get_entries_by_name(name)
performance.get_entries_by_type(entry_type)
```

The `_by_<criterion>` suffix names which attribute differs.

## Naming the type segment

The `<type>` portion names the input or output concretely. Usually one word:
`string`, `bytes`, `blob`, `buffer`, `list`, `iterator`, `url`, `request`.

When the input type is a `String` but represents something specific (a format,
encoding, or structured value), use a compound descriptor so the name is
unambiguous:

```gleam
big_int.from_string(value: String) -> Result(BigInt, BigIntError)
```

Paired with the typed version: `big_int.from_int(value: Int) -> BigInt`.

## What we don't do

### No `_with_<name>` extension variants

The ecosystem doesn't use `slice_with_type`, `redirect_with_status`,
`new_with_base`, `from_url_with_protocols`, or similar.

When a function needs an additional parameter, the ecosystem-faithful answer is:
**make it required.** `gleam_stdlib`'s `string.slice(from, at_index, length)`
doesn't have a `slice_with_length` variant — it just requires `length`.
`bit_array.slice(bits, position, length)` follows the same shape.

If the additional parameter is a configuration bundle, use the
[builder pattern](./builder-patterns.md):

```gleam
response.new(200)
|> response.set_body(json_string)
|> response.set_header("content-type", "application/json")
```

The same prohibition applies at the **variant level**, not just the function
level. `EncryptAesGcmWith(iv, additional_data, tag_length)` alongside
`EncryptAesGcm(iv)` is the same anti-pattern in PascalCase. A single variant
takes all params required, with spec defaults expressed via the bare type's
empty value (`<<>>` for `additional_data` / `label`) or `Option(_)` for
non-empty magic defaults like `tag_length: Some(128)`.

### Sanctioned exception

`web_socket.close_with(socket, code, reason)` keeps the `_with` suffix because
the bare `close(socket) -> Nil` returns no error, while `close_with` returns
`Result(Nil, WebSocketError)` for code/reason validation. Collapsing into
`close(socket, code, reason)` would force every default-close caller to unwrap.

### Helpers vs. variants

Variants must add a capability the base doesn't have. Pure convenience variants
get rejected. Test: **replicable by chaining primitives without a new
function?** If yes, the variant is unnecessary.

## Gleam-first default

Gossamer treats **`List(a)` as the canonical input type** for collections. It's
Gleam's primary data structure, what most Gleam developers reach for.

- Prefer `from_list` over `from_array`.
- `gossamer/buffer/uint8_array` and similar transit-type modules preserve their
  JS-shape conversion bridges (e.g., `to_list`, `from_list`) but the canonical
  Gleam path is via the canonical Gleam type (`BitArray` for bytes).
- No `from_array` variants should exist unless `Array` is the only realistic
  input.

## Applied examples

### `uint8_array.from_*` — multiple typed alternatives

- `from_list(List(Int))` — common way Gleam devs build byte data.
- `from_buffer(ArrayBuffer)` — view over an existing buffer.
- `from_buffer_range(ArrayBuffer, byte_offset:, length:)` — sliced view.
- `from_bit_array(BitArray)` — from canonical Gleam bytes.

No `from_array` because Gleam users prefer `List`. Users who have a
`gleam/javascript/array.Array` can `array.to_list(a) |> uint8_array.from_list`.

### `readable_stream.from_*` — two variants only

- `from_yielder(Yielder(a))`
- `from_async_yielder(AsyncYielder(a))`

`Yielder` and `AsyncYielder` are fundamentally different types (criterion 1).
Other sources (`List`, `Array`, `Uint8Array`) convert through existing methods —
chaining is acceptable since streaming a fixed collection is uncommon.

### `web_socket.send_*` — typed sender variants

- `send_text`, `send_binary`, `send_blob`.

Each names the kind of payload. No "default" — every send is typed.

### `performance.entries_by_*` — criterion variants

- `entries()`
- `entries_by_name(name)`
- `entries_by_type(entry_type)`

The base returns everything; each `_by_<criterion>` narrows by a specific
attribute.

## See also

- [Builder patterns](./builder-patterns.md) — `with_<field>` on a `Builder` is a
  distinct concept.
- [Module organization](./module-organization.md) — where typed variants live.
- [Conventions](../conventions.md) — the user-facing summary of gossamer's API
  patterns.
