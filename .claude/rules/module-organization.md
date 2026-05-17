---
paths:
  - "src/**/*.gleam"
---

# Module Organization

LLM extension for `docs/contributing/module-organization.md`. Read that
contributor doc first — it has the "keep with consumers" default, the three
split conditions (shared across unrelated modules, non-trivial API,
circular-import constraint), family-parent placement, and worked examples. This
file adds process notes the human doc deliberately omits.

## Common mistakes when generating bindings

- **Splitting prematurely.** A two-variant enum used by one consumer does not
  need its own module. Inline.
- **Sibling-owned types.** If `module_a` and `module_b` are siblings and one
  owns a type the other imports, that's asymmetric coupling. If there's a family
  parent, the type belongs there. If there isn't yet, consider creating one.
- **No-shared-type subdirectories.** Don't put `array_buffer` under a `buffer/`
  subdir just because the topic is similar to `uint8_array`. No shared type →
  flat top-level.
- **Submodules without an opaque-type constraint.** Reach for a top-level module
  first. Submodules are for types opaquely obtained through a parent's API, or
  for breaking import cycles.

## Constructor collisions

Gleam requires unique constructor names per module. When merging types into one
module:

1. Check whether the existing module has a colliding variant (especially
   `Other(String)`).
2. If yes, rename one of the colliders with a domain prefix (`OtherMethod` /
   `OtherStatus`).
3. If renaming would be awkward (collides with public API or invents a precedent
   the ecosystem doesn't have), put the type in its own module after all.

## Cross-references

- `typed-variants.md` — variant naming within a module.
- `builder-patterns.md` — where builder records live (usually same module as the
  consumer).
- `doc-comments.md` — module-level doc shape (anchor vs satellite vs
  family-parent).
