// `T` is the held value type, faithful to TS. Targets and unregister
// tokens are erased to `WeakKey` at the method level; Gleam tracks
// them via per-call generics.
export type FinalizationRegistry$<T> = FinalizationRegistry<T>;
