# Doc comments

Style guide for `///` and `////` doc comments on public types, functions, and
modules in gossamer. Distilled from the official
[Gleam conventions doc](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/),
[`gleam_stdlib`](https://hexdocs.pm/gleam_stdlib/) (the canonical minimalist
baseline), [`lustre`](https://hexdocs.pm/lustre/) (canonical rich narrative
style), and the broader ecosystem —
[`gleam_http`](https://hexdocs.pm/gleam_http/),
[`gleam_fetch`](https://hexdocs.pm/gleam_fetch/),
[`gleam_javascript`](https://hexdocs.pm/gleam_javascript/),
[`gleam_json`](https://hexdocs.pm/gleam_json/),
[`gleam_time`](https://hexdocs.pm/gleam_time/). Adapted for gossamer's
binding-library shape.

## Placement

- `///` goes immediately before the type, function, constant, or `@external`
  binding it documents.
- `////` goes at the top of the module for module-level docs.
- `//` is a regular comment; it does not appear in generated documentation.

Only placement is enforced by the compiler. Everything below is idiom drawn from
the ecosystem.

## When to add one

**Always add at least a one-sentence doc on every public type, function,
constant, and module.** Matches `gleam_stdlib` and `lustre` practice, and the
official Gleam conventions doc's
[Comment liberally](https://gleam.run/writing-gleam/conventions-patterns-and-anti-patterns/#comment-liberally):

> Make liberal use of comments. Code is read more often than it is written and
> readers benefit from comments that explain the why and the how, not just the
> what.

Even when the name is fully self-describing (`is_body_used(response) -> Bool`),
a one-sentence doc improves discoverability via `gleam docs` HTML output and
gives the maintainer a place to add nuance later without API churn.

Stronger rules layered on top of "always at least one sentence":

1. **Returns `Result` / `Option` / `Promise(Result(_, _))`** → the doc must
   explain when the error/none branch fires. Users shouldn't have to guess what
   triggers `Error`. If the error case is genuinely implausible (no throw path
   in the spec), that's a signal the function may be over-wrapped — investigate
   per [Throw detection](./throw-detection.md) rather than inventing a cause.

2. **Mutation, runtime-specific behavior, or `Other(_)`-variant fallback
   semantics** → call out the nuance explicitly.

3. **Spec terminology or non-obvious conceptual behavior** → add a paragraph
   beyond the one-sentence default and link to the relevant MDN page or spec
   section.

## Voice and style

- **Opening verb, present tense** for functions: "Creates", "Returns", "Checks",
  "Determines". Imperative voice dominates `gleam_stdlib` and `lustre`.
- **Noun-phrase openers for getters and types**: "The HTTP status of the
  response.", "A JavaScript `Map`.", "The final URL after redirects." Both forms
  are valid; pick whichever reads naturally for the binding.
- **Terse and declarative** — 1-2 sentences is the sweet spot for function docs.
  Longer narrative belongs on type docs and module docs (`////`), where framing
  helps; avoid it on individual functions.
- **Sentence case for headers and prose.** No Title Case in body text.
- **American spelling** in source-code doc comments (`behavior`, `realize`,
  `serialize`).
- **Plain vocabulary.** Use "field", "option", "parameter", "setting" — never
  "knob". The latter is informal jargon that reads poorly in user-facing docs.

## Backticks

Backticks mark Gleam tokens the reader would type or compare on, not English
names that happen to contain digits.

- **Type and identifier references:** `` `Result` ``, `` `HttpStatus` ``,
  `` `http_status.Other(code)` ``, `` `Response` ``.
- **Parameter names referenced in prose:** `` `url` ``, `` `init` ``,
  `` `chunk` ``.
- **Valid Gleam literals** — `Int`, `Float`, `String`, hex, `Bool`: `` `200` ``,
  `` `65_536` ``, `` `0xFF` ``, `` `-1.0` ``, `` `"click"` ``, `` `True` ``. Use
  Gleam's underscore-separator form for large integers (`` `4_294_967_295` ``,
  not `4294967295`).
- **JavaScript identifiers** when documenting wrapped behavior:
  `` `Promise.all` ``, `` `Symbol.for` ``, `` `element.setAttribute()` ``.

Do **not** backtick standards/encoding names (`UTF-8`, `ISO 8601`, `IEEE 754`,
`RFC 7517`), units (`bytes`, `seconds`), compound descriptors (`32-bit`,
`version 4`), expressions (`2^53 - 1`), value-class globs (`3xx`), or reason
phrases (`Found`, `OK`). These flow as plain prose.

**Ranges use en-dash between backticked endpoints**: `` `200`–`599` ``,
`` `0`–`999` ``. Not `200-599`.

## Spacing

- **Blank line before each `///` doc block** separates it from the previous
  function/type. Without this, the block visually attaches to whatever's
  directly above rather than the item it documents.
- **No blank line between the `///` block and the item it documents** — they
  must attach. Gleam enforces this.
- **Trailing empty `///` line inside the doc block** (before `@external` /
  `pub fn`) is a `gleam_stdlib` idiom, not required by Gleam. It gives the block
  a consistent visual "end" marker when scanning a file.
- **Blank `///` lines within a doc comment** separate prose from the
  `## Examples` header, and separate multiple example blocks from each other.

## Error prose

Inline, not a separate section. Idioms:

- Generic form for `Result` with bare `Nil` / `String` / `Dynamic` error:

      Returns an error if ...

- Paraphrasing a specific `Error` variant as a value:

      Returns `Error(InvalidUrl)` if `url` isn't an absolute URL.

- Multiple conditions chain with "or":

      Returns an error if `url` isn't a valid URL or `status` isn't a
      redirect status (3xx).

- For `Result(_, Nil)` / `Option(_)` (missing-value), describe what's missing:

      The response body as a `ReadableStream`. Returns an error if the
      response has no body.

## Examples

- Header is `## Examples` (plural — `gleam_stdlib` convention, even for a single
  block).
- Fence with `` ```gleam ``.
- Use labels matching the function signature.
- `assert`-based examples where equality makes sense (`gleam_stdlib`'s dominant
  form):

      /// ## Examples
      ///
      /// ```gleam
      /// assert url.can_parse("https://example.com") == True
      /// ```

- For FFI-wrapped constructors where equality on an opaque return is awkward, a
  bare call site is acceptable — the example demonstrates shape, not behavior:

      /// ## Examples
      ///
      /// ```gleam
      /// let assert Ok(stream) = compression_stream.new(compression.Gzip)
      /// ```

- For functions whose output is non-deterministic (random, timestamps) or
  awkward to assert on (large structures), use a trailing `// -> value` comment
  to show a representative output:

      /// ## Examples
      ///
      /// ```gleam
      /// int.random(10)
      /// // -> 4
      /// ```

- Multiple distinct cases → multiple separate code fences, separated by a blank
  `///` line (don't merge into one block).

Not every function needs an example. Add one when the prose can't fully convey
the shape — especially for functions taking variant-type parameters, functions
with non-obvious pipeline patterns, or where the example saves a user from
guessing.

## Cross-references

Five forms, ordered roughly from terse to fully navigable. Pick the form most
useful for the reader's intent.

### Backticks (terse mention)

Just the name in backticks. Use when the reference is a mention, not a "go look
at" pointer:

    /// The HTTP status of the response. Well-known codes return a
    /// matching `HttpStatus` variant; other codes return
    /// `http_status.Other(code)`.

### Same-module anchor links

Use when prose says "see X" or "use X to do Y" and the target is in the same
module:

    /// Use [`build`](#build) to realize the builder into a `Response`.

**Anchor case follows the identifier case:**

- Function: ``[`build`](#build)``, ``[`from_string`](#from_string)``.
- Type: ``[`Builder`](#Builder)``, ``[`ReadyState`](#ReadyState)``.
- Variant: ``[`Connecting`](#Connecting)``.

For functions ending in `_` to dodge a reserved word (`type_`, `for_`), the
anchor includes the underscore: ``[`type_`](#type_)``.

### Cross-module anchor links

Use when the reference is in a sibling module. Format the link text as
`module.name` (qualified) for clarity, and the URL as the relative HTML path:

    /// Use [`reader.read`](./reader.html#read) to pull the next chunk.
    /// See [`http.Method`](../http.html#Method) for the canonical type.

Identifiers in link text get backticks; plain English words don't.

**Deeply nested cross-references** (two or more levels of `../`) — prefer an
absolute hexdocs URL over a relative path.

### Hexdocs links for canonical Gleam types

When prose references a canonical Gleam type from another package, link to its
hexdocs page:

    /// The URL as a [`gleam/uri.Uri`](https://hexdocs.pm/gleam_stdlib/gleam/uri.html#Uri).

Common hexdocs roots:

- `gleam_stdlib`: `https://hexdocs.pm/gleam_stdlib/gleam/<module>.html`
- `gleam_javascript`:
  `https://hexdocs.pm/gleam_javascript/gleam/javascript/<module>.html`
- `gleam_http`: `https://hexdocs.pm/gleam_http/gleam/http.html`
- `gleam_fetch`: `https://hexdocs.pm/gleam_fetch/gleam/fetch.html`
- `gleam_json`: `https://hexdocs.pm/gleam_json/gleam/json.html`
- `gleam_time`: `https://hexdocs.pm/gleam_time/gleam/time/<module>.html`
- `gleam_yielder`: `https://hexdocs.pm/gleam_yielder/gleam/yielder.html`
- `gleam_regexp`: `https://hexdocs.pm/gleam_regexp/gleam/regexp.html`

### MDN and spec external links

**Placement** — MDN goes on the most specific anchor:

- If the module has an anchor **type** (a `pub type X` representing the wrapped
  JS object), the MDN link goes on that type's doc comment. This is the default
  for almost every gossamer module (`Blob`, `BigInt`, `WebSocket`,
  `ReadableStream`, etc.).
- If the module wraps a JavaScript **global namespace** with no anchor type
  (`console`, `performance`), the MDN link goes on the module-level (`////`) doc
  instead.

Don't duplicate: only one place per module gets the canonical "See X on MDN."
link.

**Format** — for Web Platform APIs:

    /// See [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response) on MDN.

For ECMAScript built-ins:

    /// See [`Symbol`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) on MDN.

Spec links are appropriate when the function documents spec-specific behavior:

- WHATWG: `[Streams Standard](https://streams.spec.whatwg.org/)`
- W3C: `[Web Crypto API](https://www.w3.org/TR/WebCryptoAPI/)`
- TC39: `[ECMA-262](https://tc39.es/ecma262/)`
- RFC: `[RFC 7231](https://datatracker.ietf.org/doc/html/rfc7231)`

Cite the spec when it's load-bearing for behavior. Don't cite for every binding.

### When to use which form

| Context                                        | Form                                    |
| ---------------------------------------------- | --------------------------------------- |
| Mention a type or identifier in prose          | Backticks                               |
| Point reader at a same-module function         | ``[`name`](#name)``                     |
| Point reader at another module in this package | ``[`module.name`](./module.html#name)`` |
| Point reader at a canonical Gleam type         | Hexdocs link                            |
| Anchor type's MDN reference                    | MDN link, separate line                 |
| Spec citation for behavior                     | Spec link inline                        |

## Notes, warnings, and tips

Use `>` blockquotes with bold-prefixed labels for callouts (`lustre` pattern):

    /// > **Note**: this mutates the underlying JavaScript object.

    /// > **Warning**: do not consume the body twice; it's a one-shot
    /// > stream.

    /// > **Tip**: chain `read` in a recursive function to drain the
    /// > stream.

Use sparingly. A surprising JavaScript semantic, a non-obvious constraint, or a
recovery hint warrants a callout. Routine prose does not.

Format: `>` then a space, then `**Label**:` (capitalized, with colon), then the
body. Multi-line callouts continue with `>` on each line.

## Type-level docs

### Anchor types (the module's primary type)

The anchor type carries the bulk of the conceptual framing for the binding:

    /// A JavaScript `Response` returned by `fetch_extra.send` or
    /// constructed via `from_*` and `set_*`.
    ///
    /// See [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response) on MDN.
    ///
    @external(javascript, "./response.type.ts", "Response$")
    pub type Response

- **One-sentence conceptual opener**, often "A JavaScript `X`...".
- **Blank `///` line, then the MDN link** on its own line ("See \[X\](url) on
  MDN.").
- **Optional**: a small usage example or constructor pointer if the constructor
  surface isn't obvious.

### Multi-variant types (states, outcomes)

Pattern: type-level doc plus per-variant docs:

    /// The state of a `WebSocket` connection.
    ///
    pub type ReadyState {
      /// The handshake is in progress.
      Connecting

      /// The connection is open and messages can be sent.
      Open

      /// `close` has been called; the closing handshake is in progress.
      Closing

      /// The connection has closed (cleanly or otherwise).
      Closed
    }

Variant docs are common in `gleam_http.Method`, `gleam_fetch.FetchError`, and
gossamer's own `StreamLifecycleError` / `BufferError`. Use them whenever each
variant has independently useful semantics.

### Opaque types

When the type's internal representation matters for interop or debugging,
document it briefly. Otherwise the conceptual opener is enough.

### Satellite types

Records, option types, and outcomes that live in the anchor module and have no
independent identity usually need only the one-sentence opener plus per-variant
docs. The parent module's framing carries them.

## Module-level docs (`////`)

**Every public module gets at least a one-line module-doc.** No exceptions. The
module is the unit users see first in `gleam docs`'s sidebar; an empty module
header is a missed orientation cue. Pick the depth based on the module's role.

### Top-level / anchor / family-parent modules (rich)

Modules that are entry points or family parents earn richer docs:

    //// One-paragraph overview of what this module covers and how it
    //// fits into gossamer.
    ////
    //// ## When to use this module
    ////
    //// Short framing — when is this binding the right choice, when
    //// is a canonical Gleam type better.
    ////
    //// ## Related modules
    ////
    //// - [`gleam/http.Method`](https://hexdocs.pm/gleam_http/gleam/http.html#Method)
    //// - [`gossamer/fetch_extra`](./fetch_extra.html) for the actual
    ////   fetch operation.

Examples-of-use sections are optional and only worth adding when the binding is
non-trivial to use.

### Submodule under a family (terse)

Submodules in a family (e.g., `gossamer/stream/readable_stream/reader`) inherit
their context from the family parent. A one-sentence overview is usually enough:

    //// A locked reader over a `ReadableStream`. See
    //// [`gossamer/stream/readable_stream`](../readable_stream.html) for
    //// the stream itself.

### Wrapping a single Web API type (Gleam-side framing)

When the module wraps a single Web Platform type, the anchor type's doc carries
the spec framing ("A JavaScript `X`..." + MDN link). The module-level doc should
give Gleam-side use context — when to reach for this binding, how it composes
with sibling modules, what to call to get started — **without** restating what
the type doc already says:

    //// The control side of the abort-signal pair. Create a
    //// controller, pass its [`signal`](#signal) to cancelable
    //// operations like `fetch_extra.send`, then call
    //// [`abort`](#abort) to cancel them.

Avoid: starting the module doc with "A JavaScript `X`..." — that phrasing
belongs on the anchor type, not the module.

### "Extras" modules

`*_extra` modules layer on top of canonical Gleam types. Open with what the
module adds on top:

    //// Extras for `gleam/string` — Unicode normalization, locale-
    //// aware comparison and case conversion, code-point
    //// construction, and UTF-16 well-formedness checks.

## Sourcing

Source doc comments from the **actual specs** (WHATWG, W3C, TC39, RFCs) or
**MDN**. MDN is maintained collaboratively by browser vendors via the Open Web
Docs initiative and is reliable for descriptions.

Type-definition files (TypeScript `lib.dom.d.ts`, Deno or Node types) and ad-hoc
sources (Stack Overflow, blog posts, tutorials) aren't authoritative
documentation — they're terse type signatures or third-party summaries that may
drift from spec or miss nuance. Verify against the spec or MDN before writing
the doc comment.

## JavaScript framing

Match the ecosystem (`gleam_javascript`, `gleam_fetch`, `lustre`) — embrace the
JavaScript framing rather than avoid it.

- **Spell out "JavaScript"** in prose. Don't abbreviate as "JS". The ecosystem
  is consistent.
- **"A JavaScript `X`..."** is the encouraged opener for anchor type docs on
  wrapped JS types: _"A JavaScript `Map`..."_, _"A JavaScript `BigInt` — an
  arbitrary-precision integer."_
- **Reference JS methods/constructors in backticks** when documenting wrapped
  behavior or equivalences: `Promise.all`, `Symbol.for`, `promise.catch`,
  `element.setAttribute()`.

**Narrow exception** — don't describe **Gleam-side** return values or fields
using JS-only value names. The Gleam side has its own answer:

- _"Returns `undefined` if the key is missing."_ — Gleam returns `Error(Nil)` /
  `None`. Reject.
- _"The default value is `null`."_ — Gleam uses `Option(_)`. Reject.
- _"Returns `Error(Nil)` if the key is missing."_ — accept.

Documenting the wrapped JS behavior is fine (_"`JSON.stringify` throws
`TypeError` on cycles"_) — that's spec documentation, not Gleam-side leak.

## What to skip

- REPL-style `>` prompt examples (`gleam_stdlib` migrated away from this).
- `@param` / `@returns` tags (not idiomatic; Gleam's types carry this info).
- Section dividers (`// ---`, `// ====`), emoji, ASCII art (except small
  diagrams in module docs when load-bearing).
- Restating the function name or return type without adding information.
- Inventing error causes for `Result` wraps that have no real failure mode (sign
  of over-wrapping).
- **Implementation details that don't change user-visible behavior**:
  "zero-copy", "shares the underlying buffer", "runs in O(N)", "natively
  implemented for performance", "uses a `WeakMap` internally". State the
  user-visible consequence instead ("the returned bytes alias the source —
  modify either and the other reflects the change", or nothing if the
  implementation is transparent).
- Redundant qualifiers ("JS-only", "this method", "init dict") or coined terms
  ("body-polymorphic"). Just describe the behavior plainly.

## Applied examples

### Function with cross-references

    /// Constructs a `UrlPattern` from the configured `Builder`. Use
    /// [`from_string`](#from_string) for a single-pattern shorthand.
    /// Returns an error if any component pattern is malformed.
    ///
    /// ## Examples
    ///
    /// ```gleam
    /// let assert Ok(pattern) =
    ///   url_pattern.new()
    ///   |> url_pattern.with_pathname("/users/:id")
    ///   |> url_pattern.build
    /// ```
    ///
    pub fn build(builder: Builder) -> Result(UrlPattern, Nil)

### Anchor type with MDN link

    /// A JavaScript `Response`, the result of a fetch operation or a
    /// value constructed via the `from_*` constructors.
    ///
    /// See [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response) on MDN.
    ///
    @external(javascript, "./response.type.ts", "Response$")
    pub type Response

### Multi-variant type with per-variant docs

    /// The state of a `WebSocket` connection.
    ///
    pub type ReadyState {
      /// The handshake is in progress.
      Connecting

      /// The connection is open and messages can flow.
      Open

      /// `close` has been called; the closing handshake is in progress.
      Closing

      /// The connection has closed.
      Closed
    }

### Getter with `Other(_)`-variant fallback

    /// The HTTP status of the response. Well-known codes return a
    /// matching `HttpStatus` variant; other codes return
    /// `http_status.Other(code)`.
    ///
    pub fn status(...)

### Bad: restates signature

    /// Returns the response's status.
    ///
    pub fn status(...)

### Bad: inventing an error cause for an over-wrapped `Result`

    /// Returns an error if JavaScript decides this is invalid.
    ///
    pub fn new(...) -> Result(Response, String)

If you can't articulate the error cause, the function may be over-wrapped;
investigate per [Throw detection](./throw-detection.md).

## See also

- [Throw detection](./throw-detection.md) — when to wrap throws in `Result`
  (informs error prose).
- [Handling runtime divergence](../../CONTRIBUTING.md#handling-runtime-divergence)
  — Pattern 1 / Pattern 2 doc notes for runtime gaps.
- [Module organization](./module-organization.md) — anchor vs satellite module
  placement (informs type doc strategy).
- [Builder patterns](./builder-patterns.md) — builder doc shape (informs which
  functions point at `[`build`](#build)`).
- [Typed variants](./typed-variants.md) — constructor naming (informs
  cross-reference prose).
