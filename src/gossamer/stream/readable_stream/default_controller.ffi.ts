import type * as $defaultController from "$/gossamer/gossamer/stream/readable_stream/default_controller.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toResult } from "~/utils/result.ffi.ts";

function closedError() {
  return Result$Error($stream.StreamLifecycleError$Closed());
}

export const desired_size: typeof $defaultController.desired_size = (
  controller,
) => {
  return toResult(controller.desiredSize);
};

export const close: typeof $defaultController.close = (controller) => {
  try {
    controller.close();
    return Result$Ok(undefined);
  } catch {
    return closedError();
  }
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
  try {
    controller.error(reason);
    return Result$Ok(undefined);
  } catch {
    return closedError();
  }
};
