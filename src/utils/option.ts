import {
  type Option$,
  Option$None,
  Option$Some,
} from "$/gleam_stdlib/gleam/option.mjs";

export function toOption<T>(value: T | null | undefined): Option$<T> {
  return value === null || value === undefined
    ? Option$None()
    : Option$Some(value);
}
