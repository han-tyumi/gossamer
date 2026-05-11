import * as $runtime from "$/gossamer/runtime.mjs";

export const current: typeof $runtime.current = () => {
  if ("Deno" in globalThis) return $runtime.Runtime$Deno();
  if ("Bun" in globalThis) return $runtime.Runtime$Bun();
  return $runtime.Runtime$Node();
};
