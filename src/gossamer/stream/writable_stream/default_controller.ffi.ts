import type * as $defaultController from "$/gossamer/gossamer/stream/writable_stream/default_controller.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

export const signal: typeof $defaultController.signal = (controller) => {
  return controller.signal;
};

export const error: typeof $defaultController.error = (controller, reason) => {
  try {
    controller.error(reason);
    return Result$Ok(undefined);
  } catch {
    return Result$Error($stream.StreamLifecycleError$Closed());
  }
};
