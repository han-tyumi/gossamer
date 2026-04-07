import type * as $abortController from "$/gossamer/gossamer/abort_controller.mjs";

export type AbortController$ = AbortController;

export const new_: typeof $abortController.new$ = () => {
  return new AbortController();
};

export const signal: typeof $abortController.signal = (
  controller: AbortController,
) => {
  return controller.signal;
};

export const abort: typeof $abortController.abort = (
  controller: AbortController,
  reason,
) => {
  controller.abort(reason);
  return controller;
};
