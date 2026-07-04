import { isIndexable } from "~/utils/object.ffi.ts";

/**
 * Throws a diagnostic `Error` if `obj[method]` is not a function on this
 * runtime. Otherwise returns silently.
 *
 * Use at FFI boundaries where the binding requires a JS API some target
 * runtimes don't ship (e.g., `RegExp.escape` not in older Node,
 * `ReadableStream.from` not in Bun). Replaces the cryptic native
 * `TypeError: undefined is not a function` with a message naming the
 * binding and an upstream tracker URL.
 *
 * @param obj      The host object (e.g., `RegExp`, `ReadableStream`).
 * @param method   The method name to check (e.g., `"escape"`, `"from"`).
 * @param binding  The Gleam-side binding name for the message
 *                 (e.g., `"regexp_extra.escape"`).
 * @param issueUrl Optional upstream tracker URL or minimum-version hint.
 */
export function ensureMethod(
  obj: unknown,
  method: string,
  binding: string,
  issueUrl?: string,
): void {
  // Host objects are usually constructors, so function values must pass
  // the guard alongside plain objects.
  if (
    (isIndexable(obj) || typeof obj === "function") &&
    typeof Reflect.get(obj, method) === "function"
  ) return;
  const suffix = issueUrl ? ` - see ${issueUrl}` : "";
  throw new Error(
    `gossamer.${binding} is unavailable on this runtime${suffix}`,
  );
}
