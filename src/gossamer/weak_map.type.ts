// `_K` is phantom: Gleam tracks the key type but JS `WeakMap` erases
// it to `WeakKey`. A constrained `K extends WeakKey` would fail
// against Gleam's own unconstrained `.d.mts` output.
export type WeakMap$<_K, V> = WeakMap<WeakKey, V>;
