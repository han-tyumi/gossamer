import type * as $error from "$/gossamer/gossamer/error.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export type Error$ = Error;

export const new_: typeof $error.new$ = (message) => {
  return new Error(message);
};

export const type_error: typeof $error.type_error = (message) => {
  return new TypeError(message);
};

export const range_error: typeof $error.range_error = (message) => {
  return new RangeError(message);
};

export const reference_error: typeof $error.reference_error = (message) => {
  return new ReferenceError(message);
};

export const syntax_error: typeof $error.syntax_error = (message) => {
  return new SyntaxError(message);
};

export const uri_error: typeof $error.uri_error = (message) => {
  return new URIError(message);
};

export const eval_error: typeof $error.eval_error = (message) => {
  return new EvalError(message);
};

export const name: typeof $error.name = (error) => {
  return error.name;
};

export const message: typeof $error.message = (error) => {
  return error.message;
};

export const stack: typeof $error.stack = (error) => {
  return toResult(error.stack);
};

export const cause: typeof $error.cause = (error) => {
  return toResult(error.cause);
};
