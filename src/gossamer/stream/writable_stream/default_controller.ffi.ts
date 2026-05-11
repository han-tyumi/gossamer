import type * as $defaultController from "$/gossamer/gossamer/stream/writable_stream/default_controller.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const signal: typeof $defaultController.signal = (controller) => {
  return controller.signal;
};

export const error: typeof $defaultController.error = (controller, reason) => {
  return toResult.fromThrows(() => {
    controller.error(reason);
    return undefined;
  });
};
