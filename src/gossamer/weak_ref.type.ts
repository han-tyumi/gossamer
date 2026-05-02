// `_T` is phantom: Gleam tracks the target type but JS `WeakRef`
// erases it to `WeakKey`. A constrained `T extends WeakKey` would
// fail against Gleam's own unconstrained `.d.mts` output.
export type WeakRef$<_T> = WeakRef<WeakKey>;
