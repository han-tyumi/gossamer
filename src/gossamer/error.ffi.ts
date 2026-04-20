import type * as $error from "$/gossamer/gossamer/error.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export type Error$ = Error;

export const new_: typeof $error.new$ = (message) => {
  return new Error(message);
};

export const new_with_cause: typeof $error.new_with_cause = (
  message,
  cause,
) => {
  return new Error(message, { cause });
};

export const type_error: typeof $error.type_error = (message) => {
  return new TypeError(message);
};

export const type_error_with_cause: typeof $error.type_error_with_cause = (
  message,
  cause,
) => {
  return new TypeError(message, { cause });
};

export const range_error: typeof $error.range_error = (message) => {
  return new RangeError(message);
};

export const range_error_with_cause: typeof $error.range_error_with_cause = (
  message,
  cause,
) => {
  return new RangeError(message, { cause });
};

export const reference_error: typeof $error.reference_error = (message) => {
  return new ReferenceError(message);
};

export const reference_error_with_cause:
  typeof $error.reference_error_with_cause = (message, cause) => {
    return new ReferenceError(message, { cause });
  };

export const syntax_error: typeof $error.syntax_error = (message) => {
  return new SyntaxError(message);
};

export const syntax_error_with_cause: typeof $error.syntax_error_with_cause = (
  message,
  cause,
) => {
  return new SyntaxError(message, { cause });
};

export const uri_error: typeof $error.uri_error = (message) => {
  return new URIError(message);
};

export const uri_error_with_cause: typeof $error.uri_error_with_cause = (
  message,
  cause,
) => {
  return new URIError(message, { cause });
};

export const eval_error: typeof $error.eval_error = (message) => {
  return new EvalError(message);
};

export const eval_error_with_cause: typeof $error.eval_error_with_cause = (
  message,
  cause,
) => {
  return new EvalError(message, { cause });
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
