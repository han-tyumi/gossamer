import type * as $abortController from "$/gossamer/gossamer/abort_controller.mjs";

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
) => {
  controller.abort();
  return controller;
};

export const abort_with: typeof $abortController.abort_with = (
  controller: AbortController,
  reason,
) => {
  controller.abort(reason);
  return controller;
};
