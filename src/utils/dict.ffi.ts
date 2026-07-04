import * as dict$ from "$/gleam_stdlib/gleam/dict.mjs";

export function toObjectWithMap<K extends string | number | symbol, V, VV>(
  dict: dict$.Dict$<K, V>,
  map: (value: V) => VV,
): Record<K, VV> {
  // Null prototype so a "__proto__" key becomes an own property instead
  // of hitting the inherited Object.prototype accessor and being dropped.
  const acc: Record<K, VV> = Object.create(null);
  dict$.each(dict, (key: K, value: V) => {
    acc[key] = map(value);
  });
  return acc;
}

export function toObject<K extends string | number | symbol, V>(
  dict: dict$.Dict$<K, V>,
): Record<K, V> {
  return toObjectWithMap(dict, (value: V) => value);
}
