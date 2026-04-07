import type * as $domException from "$/gossamer/gossamer/dom_exception.mjs";

export type DOMException$ = DOMException;

export const new_: typeof $domException.new$ = (message, name) => {
  return new DOMException(message, name);
};

export const message: typeof $domException.message = (exception) => {
  return exception.message;
};

export const name: typeof $domException.name = (exception) => {
  return exception.name;
};

export const code: typeof $domException.code = (exception) => {
  return exception.code;
};
