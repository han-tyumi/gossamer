import type * as $defaultController from "$/gossamer/gossamer/transform_stream/default_controller.mjs";
import { toOption } from "~/utils/option.ts";

export type DefaultController$<T> = TransformStreamDefaultController<T>;

export const desired_size: typeof $defaultController.desired_size = (
  controller,
) => {
  return toOption(controller.desiredSize);
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

export const terminate: typeof $defaultController.terminate = (controller) => {
  controller.terminate();
};
