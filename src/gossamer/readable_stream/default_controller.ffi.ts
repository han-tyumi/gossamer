import type * as $defaultController from "$/gossamer/gossamer/readable_stream/default_controller.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export type DefaultController$<T> = ReadableStreamDefaultController<T>;

export const desired_size: typeof $defaultController.desired_size = (
  controller,
) => {
  return toResult(controller.desiredSize);
};

export const close: typeof $defaultController.close = (controller) => {
  return toResult.fromThrows(() => {
    controller.close();
    return undefined;
  });
};

export const enqueue: typeof $defaultController.enqueue = (
  controller,
  chunk,
) => {
  return toResult.fromThrows(() => {
    controller.enqueue(chunk);
    return undefined;
  });
};

export const error: typeof $defaultController.error = (controller, reason) => {
  return toResult.fromThrows(() => {
    controller.error(reason);
    return undefined;
  });
};
