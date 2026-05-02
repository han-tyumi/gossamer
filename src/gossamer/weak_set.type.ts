// `_V` is phantom: Gleam tracks the value type but JS `WeakSet`
// erases it to `WeakKey`. A constrained `V extends WeakKey` would
// fail against Gleam's own unconstrained `.d.mts` output.
export type WeakSet$<_V> = WeakSet<WeakKey>;
