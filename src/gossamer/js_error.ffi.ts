import type * as $jsError from "$/gossamer/gossamer/js_error.mjs";
import * as $kind from "$/gossamer/gossamer/js_error/kind.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export type JsError$ = Error;

export const new_: typeof $jsError.new$ = (message) => {
  return new Error(message);
};

export const new_with_cause: typeof $jsError.new_with_cause = (
  message,
  cause,
) => {
  return new Error(message, { cause });
};

export const type_error: typeof $jsError.type_error = (message) => {
  return new TypeError(message);
};

export const type_error_with_cause: typeof $jsError.type_error_with_cause = (
  message,
  cause,
) => {
  return new TypeError(message, { cause });
};

export const range_error: typeof $jsError.range_error = (message) => {
  return new RangeError(message);
};

export const range_error_with_cause: typeof $jsError.range_error_with_cause = (
  message,
  cause,
) => {
  return new RangeError(message, { cause });
};

export const reference_error: typeof $jsError.reference_error = (message) => {
  return new ReferenceError(message);
};

export const reference_error_with_cause:
  typeof $jsError.reference_error_with_cause = (message, cause) => {
    return new ReferenceError(message, { cause });
  };

export const syntax_error: typeof $jsError.syntax_error = (message) => {
  return new SyntaxError(message);
};

export const syntax_error_with_cause: typeof $jsError.syntax_error_with_cause =
  (
    message,
    cause,
  ) => {
    return new SyntaxError(message, { cause });
  };

export const uri_error: typeof $jsError.uri_error = (message) => {
  return new URIError(message);
};

export const uri_error_with_cause: typeof $jsError.uri_error_with_cause = (
  message,
  cause,
) => {
  return new URIError(message, { cause });
};

export const eval_error: typeof $jsError.eval_error = (message) => {
  return new EvalError(message);
};

export const eval_error_with_cause: typeof $jsError.eval_error_with_cause = (
  message,
  cause,
) => {
  return new EvalError(message, { cause });
};

export const name: typeof $jsError.name = (error) => {
  return error.name;
};

export const message: typeof $jsError.message = (error) => {
  return error.message;
};

export const stack: typeof $jsError.stack = (error) => {
  return toResult(error.stack);
};

export const cause: typeof $jsError.cause = (error) => {
  return toResult(error.cause);
};

export const kind: typeof $jsError.kind = (error) => {
  if (error instanceof DOMException) {
    return $kind.JsErrorKind$DomException(error.name);
  }
  switch (error.name) {
    case "TypeError":
      return $kind.JsErrorKind$TypeError();
    case "RangeError":
      return $kind.JsErrorKind$RangeError();
    case "ReferenceError":
      return $kind.JsErrorKind$ReferenceError();
    case "SyntaxError":
      return $kind.JsErrorKind$SyntaxError();
    case "URIError":
      return $kind.JsErrorKind$UriError();
    case "EvalError":
      return $kind.JsErrorKind$EvalError();
    case "AggregateError":
      return $kind.JsErrorKind$AggregateError();
    default:
      return $kind.JsErrorKind$Other(error.name);
  }
};
