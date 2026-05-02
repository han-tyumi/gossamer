import * as $dict from "$/gleam_stdlib/gleam/dict.mjs";
import * as $regexp from "$/gossamer/gossamer/regexp.mjs";
import { flagChar, fromFlagChar } from "~/gossamer/regexp_flag.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function flagsToString(
  flags: Parameters<typeof $regexp.new_with>[1],
): string {
  return toArray(flags).map(flagChar).sort().join("");
}

function stringToFlags(
  source: string,
): ReturnType<typeof $regexp.flags> {
  const result = [];
  for (const char of source) {
    const flag = fromFlagChar(char);
    if (flag !== undefined) result.push(flag);
  }
  return fromArray(result);
}

export const new_: typeof $regexp.new$ = (pattern) => {
  return toResult.fromThrows(() => new RegExp(pattern));
};

export const new_with: typeof $regexp.new_with = (pattern, flags) => {
  return toResult.fromThrows(() => new RegExp(pattern, flagsToString(flags)));
};

export const escape: typeof $regexp.escape = (string) => {
  return RegExp.escape(string);
};

export const source: typeof $regexp.source = (regex) => regex.source;

export const flags: typeof $regexp.flags = (regex) =>
  stringToFlags(regex.flags);

export const last_index: typeof $regexp.last_index = (regex) => regex.lastIndex;

export const set_last_index: typeof $regexp.set_last_index = (regex, index) => {
  regex.lastIndex = index;
  return regex;
};

export const is_global: typeof $regexp.is_global = (regex) => regex.global;

export const is_ignore_case: typeof $regexp.is_ignore_case = (regex) =>
  regex.ignoreCase;

export const is_multiline: typeof $regexp.is_multiline = (regex) =>
  regex.multiline;

export const is_dot_all: typeof $regexp.is_dot_all = (regex) => regex.dotAll;

export const is_unicode: typeof $regexp.is_unicode = (regex) => regex.unicode;

export const is_unicode_sets: typeof $regexp.is_unicode_sets = (regex) =>
  regex.unicodeSets;

export const is_sticky: typeof $regexp.is_sticky = (regex) => regex.sticky;

export const has_indices: typeof $regexp.has_indices = (regex) =>
  regex.hasIndices;

export const test_: typeof $regexp.test_ = (regex, input) => regex.test(input);

export const exec: typeof $regexp.exec = (regex, input) => {
  const result = regex.exec(input);
  if (result === null) return toResult(null);

  const captures = fromArray(result.slice(1).map((c) => toOption(c)));

  const namedEntries: [string, string][] = [];
  if (result.groups) {
    for (const [key, value] of Object.entries(result.groups)) {
      if (value !== undefined) namedEntries.push([key, value]);
    }
  }
  const namedCaptures = $dict.from_list(fromArray(namedEntries));

  return toResult(
    $regexp.Match$Match(result[0], captures, namedCaptures, result.index ?? 0),
  );
};
