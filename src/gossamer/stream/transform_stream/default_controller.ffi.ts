import type * as $defaultController from "$/gossamer/gossamer/stream/transform_stream/default_controller.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toDesiredSize } from "~/gossamer/stream.ffi.ts";

function closedError() {
  return Result$Error($stream.StreamLifecycleError$Closed());
}

export const desired_size: typeof $defaultController.desired_size = (
  controller,
) => {
  return toDesiredSize(controller.desiredSize);
};

export const enqueue: typeof $defaultController.enqueue = (
  controller,
  chunk,
) => {
  try {
    controller.enqueue(chunk);
    return Result$Ok(undefined);
  } catch {
    return closedError();
  }
};

export const error: typeof $defaultController.error = (controller, reason) => {
  controller.error(reason);
};

export const terminate: typeof $defaultController.terminate = (controller) => {
  controller.terminate();
};
