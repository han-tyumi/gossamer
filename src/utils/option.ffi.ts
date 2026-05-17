import {
  type Option$,
  Option$isNone,
  Option$None,
  Option$Some,
  Option$Some$0,
} from "$/gleam_stdlib/gleam/option.mjs";

export function toOption<T>(value: T | null | undefined): Option$<T> {
  return value === null || value === undefined
    ? Option$None()
    : Option$Some(value);
}

/**
 * Wraps a transformed value as `Some` when the source is non-null and
 * non-undefined; returns `None` otherwise. Useful when the JS value
 * needs a Gleam-side conversion before becoming the `Option`'s inner
 * value.
 */
export function mapOption<T, U>(
  value: T | null | undefined,
  transform: (value: T) => U,
): Option$<U> {
  return value === null || value === undefined
    ? Option$None()
    : Option$Some(transform(value));
}

/**
 * Assigns `target[key]` from `option` when `option` is `Some`. Use when
 * the option's inner type matches the target field exactly.
 */
export function setIfSome<T extends object, K extends keyof T>(
  target: T,
  key: K,
  option: Option$<T[K]>,
): void {
  if (Option$isNone(option)) return;
  target[key] = Option$Some$0(option);
}

/**
 * Assigns `target[key]` from `option` when `option` is `Some`, applying
 * `transform` first. Use when the option's inner type doesn't match the
 * target field directly (e.g., converting a Gleam enum to a JS string).
 */
export function mapIfSome<T extends object, K extends keyof T, V>(
  target: T,
  key: K,
  option: Option$<V>,
  transform: (value: V) => T[K],
): void {
  if (Option$isNone(option)) return;
  target[key] = transform(Option$Some$0(option));
}
