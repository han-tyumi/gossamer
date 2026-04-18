import * as $json from "$/gossamer/gossamer/json.mjs";
import * as $dict from "$/gleam_stdlib/gleam/dict.mjs";
import { toObjectWithMap } from "~/utils/dict.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

type Json = null | boolean | number | string | Json[] | { [key: string]: Json };

function gleamJsonReviver(_key: string, value: unknown) {
  if (value === null) {
    return $json.Json$Null();
  }
  if (typeof value === "boolean") {
    return $json.Json$Boolean(value);
  }
  if (typeof value === "number") {
    return $json.Json$Number(value);
  }
  if (typeof value === "string") {
    return $json.Json$String(value);
  }
  if (Array.isArray(value)) {
    return $json.Json$Array(fromArray(value));
  }
  if (typeof value === "object") {
    const entries = Object.entries(value as Record<string, unknown>);
    return $json.Json$Object($dict.from_list(fromArray(entries)));
  }
}

export const parse: typeof $json.parse = (text) => {
  return toResult.fromThrows(() => JSON.parse(text, gleamJsonReviver));
};

function jsonToObject(json: $json.Json$): Json {
  if ($json.Json$isNull(json)) {
    return null;
  }
  if ($json.Json$isBoolean(json)) {
    return $json.Json$Boolean$0(json);
  }
  if ($json.Json$isNumber(json)) {
    return $json.Json$Number$0(json);
  }
  if ($json.Json$isString(json)) {
    return $json.Json$String$0(json);
  }
  if ($json.Json$isArray(json)) {
    return toArray($json.Json$Array$0(json)).map((child) =>
      jsonToObject(child)
    );
  }
  if ($json.Json$isObject(json)) {
    return toObjectWithMap($json.Json$Object$0(json), jsonToObject);
  }
  throw new Error("unknown Gleam Json instance");
}

export const stringify: typeof $json.stringify = (json) => {
  return JSON.stringify(jsonToObject(json));
};
