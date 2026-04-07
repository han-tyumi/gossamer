import type * as $defaultController from "$/gossamer/gossamer/readable_stream/default_controller.mjs";
import { toOption } from "~/utils/option.ts";

export type DefaultController$<T> = ReadableStreamDefaultController<T>;

export const desired_size: typeof $defaultController.desired_size = (
  controller,
) => {
  return toOption(controller.desiredSize);
};

export const close: typeof $defaultController.close = (controller) => {
  controller.close();
};

export const enqueue: typeof $defaultController.enqueue = (
  controller,
  chunk,
) => {
  controller.enqueue(chunk);
};

export const error: typeof $defaultController.error = (controller, reason) => {
  controller.error(reason);
};
