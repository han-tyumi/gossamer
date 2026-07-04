/**
 * Type guard for a `MessagePort`. Duck-types via `constructor.name`
 * because Node ships its own `MessagePort` class in `node:worker_threads`
 * that the global `MessagePort` constructor isn't reachable from, but
 * both share the spec'd class name.
 */
export function isMessagePort(value: unknown): value is MessagePort {
  return typeof value === "object" && value !== null &&
    (value as { constructor?: { name?: string } }).constructor?.name ===
      "MessagePort";
}

/**
 * Walks a structured-clone payload and returns every `MessagePort`
 * reachable from it. Used to build the transfer list automatically:
 * `MessagePort` is not cloneable, so any port inside the payload must
 * be in the transfer list or the clone fails. Skips typed-array buffers
 * because their elements are bytes, not transferables.
 */
export function collectPorts(value: unknown): MessagePort[] {
  const acc: MessagePort[] = [];
  walk(value, acc, new WeakSet());
  return acc;
}

function walk(value: unknown, acc: MessagePort[], seen: WeakSet<object>): void {
  if (value === null || typeof value !== "object") return;
  if (seen.has(value)) return;
  seen.add(value);

  if (isMessagePort(value)) {
    acc.push(value);
    return;
  }

  if (ArrayBuffer.isView(value) || value instanceof ArrayBuffer) return;

  if (Array.isArray(value)) {
    for (const item of value) walk(item, acc, seen);
    return;
  }

  if (value instanceof Map) {
    for (const [key, item] of value) {
      walk(key, acc, seen);
      walk(item, acc, seen);
    }
    return;
  }

  if (value instanceof Set) {
    for (const item of value) walk(item, acc, seen);
    return;
  }

  for (const key of Object.keys(value)) {
    walk((value as Record<string, unknown>)[key], acc, seen);
  }
}
