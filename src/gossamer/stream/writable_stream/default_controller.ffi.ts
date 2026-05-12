import type * as $defaultController from "$/gossamer/gossamer/stream/writable_stream/default_controller.mjs";

export const signal: typeof $defaultController.signal = (controller) => {
  return controller.signal;
};

export const error: typeof $defaultController.error = (controller, reason) => {
  controller.error(reason);
};
