import type * as $finalizationRegistry from "$/gossamer/gossamer/finalization_registry.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $finalizationRegistry.new$ = (callback) => {
  return new FinalizationRegistry(callback);
};

export const register: typeof $finalizationRegistry.register = (
  registry,
  target,
  held,
) => {
  return toResult.fromThrows(() => {
    registry.register(target, held);
    return registry;
  });
};

export const register_with_token:
  typeof $finalizationRegistry.register_with_token = (
    registry,
    target,
    held,
    token,
  ) => {
    return toResult.fromThrows(() => {
      registry.register(target, held, token);
      return registry;
    });
  };

export const unregister: typeof $finalizationRegistry.unregister = (
  registry,
  token,
) => {
  return toResult.fromThrows(() => {
    registry.unregister(token);
    return registry;
  });
};
