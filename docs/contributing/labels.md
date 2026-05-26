# Labels

Label every parameter on multi-arg functions. The function call is a sentence —
labels are the grammatical connectors. The right label often falls out of
parsing the function name: find the English preposition or conjunction that
links the parameter to the action.

## When to skip labels

- **Any single-arg function.** The official ecosystem (`gleam_stdlib`,
  `gleam_http`, `gleam_javascript`, `gleam_fetch`) leaves single-arg parameters
  unlabelled, including noun getters. `string.length(string:)`,
  `request.path_segments(request:)`, `symbol.description(symbol:)`. Match the
  dominant ecosystem pattern.
- **Verbs where the sentence is complete:** `clone(request)`, `reverse(array)`,
  `close(stream)`.
- **Predicates:** `is_locked(stream)`, `can_parse(url)`.
- **Constructors and static methods:** `resolve(value)`, `new(url)`.
- **Record-field setters** (record-builder shape): positional, no labels.
  `set_host(req: Request(body), host: String)` mirrors `gleam_http`.

## Label patterns for multi-arg functions

| Pattern                         | Label                    | Example                                                          |
| ------------------------------- | ------------------------ | ---------------------------------------------------------------- |
| Idiomatic noun                  | varies                   | `reason(for signal:)`                                            |
| Collection append               | `to`                     | `append(to headers:, name name:, value value:)`                  |
| Collection get / delete         | `from`                   | `get(from headers:, name name:)`                                 |
| Collection has / set            | `in`                     | `has(in headers:, name name:)`                                   |
| Transform callback              | `with`                   | `map(over array:, with callback:)`                               |
| Sort / compare callback         | `by`                     | `sort(array:, by compare:)`                                      |
| Filter predicate                | `keeping`                | `filter(in array:, keeping predicate:)`                          |
| All / any test                  | `satisfying`             | `every(in array:, satisfying predicate:)`                        |
| Find predicate                  | `one_that`               | `find(in array:, one_that predicate:)`                           |
| Continuation callback           | `apply`                  | `promise.then(promise:, apply onfulfilled:)`                     |
| Side-effect callback            | `run`                    | `for_each(in headers:, run callback:)`                           |
| Fold / reduce                   | `over` / `from` / `with` | `reduce(over array:, from initial:, with callback:)`             |
| Range start / end               | `from` / `to`            | `slice(blob:, from start:, to end:)`                             |
| Upper bound (when `to` is used) | `up_to`                  | `copy_within_range(array:, to target:, from start:, up_to end:)` |
| Positional index                | `at_index`               | `with(array:, at_index index:, value value:)`                    |
| Delay (one-shot)                | `after`                  | `set_timeout(after delay:, run callback:)`                       |
| Delay (recurring)               | `every`                  | `set_interval(every delay:, run callback:)`                      |
| Base URL                        | `relative_to`            | `url_pattern.parse(pattern:, relative_to base:)`                 |
| Pattern matching                | `against`                | `url_pattern.matches(pattern:, against input:)`                  |
| File / exception name           | `named`                  | `file.from_strings(parts:, named name:)`                         |
| Assertion condition             | `that`                   | `console.log_if_false(that condition:, log data:)`               |
| Assertion data                  | `log`                    | `console.log_if_false(that condition:, log data:)`               |
| High-arity attributes           | self-labels              | `encrypt(algorithm algorithm:, key key:, data data:)`            |

## Definition readability

Both call site and definition should read well.

- Avoid label-parameter stutter like `from from_index:` — use `from index:`
  instead.
- Self-labels like `value value:` are acceptable (`gleam_stdlib` does
  `times times:`).
- Long stutters like `derived_key_type derived_key_type:` should use a shorter
  internal name: `derived_key_type type_:`.

## Side-effect callbacks

When a callback's return value is discarded, use a generic return type:
`fn(Int) -> b` not `fn(Int) -> Nil`. This matches `list.each` and avoids forcing
callers to return `Nil`.

## See also

- [Typed variants](./typed-variants.md) — variant naming and the operations
  these labels attach to.
- [Builder patterns](./builder-patterns.md) — `with_<field>` and `set_<field>`
  setters use distinct label conventions.
- [Gleam's "Use labelled arguments where helpful"](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/#use-labelled-arguments-where-helpful)
  — the official guidance gossamer's framework builds on.
