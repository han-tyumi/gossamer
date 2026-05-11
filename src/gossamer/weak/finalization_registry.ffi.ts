import type * as $finalizationRegistry from "$/gossamer/gossamer/weak/finalization_registry.mjs";
import * as $weak from "$/gossamer/gossamer/weak.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

function invalidTarget() {
  return Result$Error($weak.WeakKeyError$InvalidTarget());
}

export const new_: typeof $finalizationRegistry.new$ = (callback) => {
  return new FinalizationRegistry(callback);
};

export const register: typeof $finalizationRegistry.register = (
  registry,
  target,
  held,
) => {
  try {
    registry.register(target, held);
    return Result$Ok(registry);
  } catch {
    return invalidTarget();
  }
};

export const register_with_token:
  typeof $finalizationRegistry.register_with_token = (
    registry,
    target,
    held,
    token,
  ) => {
    try {
      registry.register(target, held, token);
      return Result$Ok(registry);
    } catch {
      return invalidTarget();
    }
  };

export const unregister: typeof $finalizationRegistry.unregister = (
  registry,
  token,
) => {
  try {
    registry.unregister(token);
    return Result$Ok(registry);
  } catch {
    return invalidTarget();
  }
};
