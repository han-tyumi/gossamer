import {
  type List,
  List$Empty,
  List$isNonEmpty,
  List$NonEmpty,
  List$NonEmpty$first,
  List$NonEmpty$rest,
} from "$/prelude.mjs";

export function fromArray<T>(array: T[]): List<T> {
  let list: List<T> = List$Empty();
  for (let i = array.length - 1; i >= 0; --i) {
    list = List$NonEmpty(array[i], list);
  }
  return list;
}

export function fromArrayMapped<T, U>(
  array: T[],
  map: (v: T, k: number) => U,
): List<U> {
  let list: List<U> = List$Empty();
  for (let i = array.length - 1; i >= 0; --i) {
    list = List$NonEmpty(map(array[i], i), list);
  }
  return list;
}

export function toArray<T>(list: List<T>): T[] {
  const array: T[] = [];
  let current = list;
  while (List$isNonEmpty(current)) {
    // deno-lint-ignore no-non-null-assertion
    array.push(List$NonEmpty$first(current)!);
    // deno-lint-ignore no-non-null-assertion
    current = List$NonEmpty$rest(current)!;
  }
  return array;
}
