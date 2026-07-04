import { Result$Error, Result$Ok } from "$/prelude.mjs";
import * as $runtime from "$/gossamer/runtime.mjs";

export const current: typeof $runtime.current = () => {
  if ("Deno" in globalThis) return $runtime.Runtime$Deno();
  if ("Bun" in globalThis) return $runtime.Runtime$Bun();
  return $runtime.Runtime$Node();
};

export const is_macos: typeof $runtime.is_macos = () => {
  return globalThis.process?.platform === "darwin" ||
    globalThis.Deno?.build.os === "darwin";
};

export const catch_panic: typeof $runtime.catch_panic = (thunk) => {
  try {
    return Result$Ok(thunk());
  } catch (error) {
    return Result$Error(
      error instanceof Error ? error.message : String(error),
    );
  }
};
