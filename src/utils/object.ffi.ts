/**
 * Type guard narrowing `unknown` to `Record<string, unknown>`. Returns
 * true for any non-null object, which is sufficient for safe dynamic
 * string-key indexing.
 */
export function isIndexable(
  value: unknown,
): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}
