import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import type * as $string from "$/gossamer/gossamer/string.mjs";
import { fromArray, toArray } from "~/utils/list.ts";
import { toNormalizationForm } from "~/gossamer/string/normalization_form.ts";
import { toResult } from "~/utils/result.ts";

export const from_char_code: typeof $string.from_char_code = (code) =>
  String.fromCharCode(code);

export const from_char_codes: typeof $string.from_char_codes = (codes) =>
  String.fromCharCode(...toArray(codes));

export const from_code_point: typeof $string.from_code_point = (code) =>
  toResult.fromThrows(() => String.fromCodePoint(code));

export const from_code_points: typeof $string.from_code_points = (codes) =>
  toResult.fromThrows(() => String.fromCodePoint(...toArray(codes)));

export const at: typeof $string.at = (string, index) =>
  toResult(string.at(index));

export const char_code_at: typeof $string.char_code_at = (string, index) => {
  const code = string.charCodeAt(index);
  return Number.isNaN(code) ? toResult(undefined) : toResult(code);
};

export const code_point_at: typeof $string.code_point_at = (string, index) =>
  toResult(string.codePointAt(index));

export const normalize: typeof $string.normalize = (string) =>
  string.normalize();

export const normalize_with: typeof $string.normalize_with = (string, form) =>
  string.normalize(toNormalizationForm(form));

export const locale_compare: typeof $string.locale_compare = (
  string,
  other,
) => {
  const result = string.localeCompare(other);
  if (result < 0) return $order.Order$Lt();
  if (result > 0) return $order.Order$Gt();
  return $order.Order$Eq();
};

export const to_locale_lower_case: typeof $string.to_locale_lower_case = (
  string,
) => string.toLocaleLowerCase();

export const to_locale_upper_case: typeof $string.to_locale_upper_case = (
  string,
) => string.toLocaleUpperCase();

export const is_well_formed: typeof $string.is_well_formed = (string) =>
  string.isWellFormed();

export const to_well_formed: typeof $string.to_well_formed = (string) =>
  string.toWellFormed();

export const index_of: typeof $string.index_of = (string, search) =>
  string.indexOf(search);

export const index_of_from: typeof $string.index_of_from = (
  string,
  search,
  position,
) => string.indexOf(search, position);

export const last_index_of: typeof $string.last_index_of = (string, search) =>
  string.lastIndexOf(search);

export const last_index_of_from: typeof $string.last_index_of_from = (
  string,
  search,
  position,
) => string.lastIndexOf(search, position);

export const slice: typeof $string.slice = (string, start, end) =>
  string.slice(start, end);

export const length: typeof $string.length = (string) => string.length;

export const concat: typeof $string.concat = (string, other) =>
  string.concat(other);

export const includes: typeof $string.includes = (string, search) =>
  string.includes(search);

export const includes_from: typeof $string.includes_from = (
  string,
  search,
  position,
) => string.includes(search, position);

export const starts_with: typeof $string.starts_with = (string, prefix) =>
  string.startsWith(prefix);

export const starts_with_from: typeof $string.starts_with_from = (
  string,
  prefix,
  position,
) => string.startsWith(prefix, position);

export const ends_with: typeof $string.ends_with = (string, suffix) =>
  string.endsWith(suffix);

export const ends_with_within: typeof $string.ends_with_within = (
  string,
  suffix,
  length,
) => string.endsWith(suffix, length);

export const replace: typeof $string.replace = (string, pattern, replacement) =>
  string.replace(pattern, replacement);

export const replace_all: typeof $string.replace_all = (
  string,
  pattern,
  replacement,
) => string.replaceAll(pattern, replacement);

export const split: typeof $string.split = (string, separator) =>
  fromArray(string.split(separator));

export const split_with_limit: typeof $string.split_with_limit = (
  string,
  separator,
  limit,
) => fromArray(string.split(separator, limit));

export const to_lower_case: typeof $string.to_lower_case = (string) =>
  string.toLowerCase();

export const to_upper_case: typeof $string.to_upper_case = (string) =>
  string.toUpperCase();

export const trim: typeof $string.trim = (string) => string.trim();

export const trim_start: typeof $string.trim_start = (string) =>
  string.trimStart();

export const trim_end: typeof $string.trim_end = (string) => string.trimEnd();

export const repeat: typeof $string.repeat = (string, times) =>
  string.repeat(times);

export const pad_start: typeof $string.pad_start = (
  string,
  target_length,
  pad,
) => string.padStart(target_length, pad);

export const pad_end: typeof $string.pad_end = (string, target_length, pad) =>
  string.padEnd(target_length, pad);

export const substring: typeof $string.substring = (string, start, end) =>
  string.substring(start, end);
