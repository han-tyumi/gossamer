import * as $worker from "$/gossamer/gossamer/worker.mjs";
import {
  type Option$,
  Option$isNone,
  Option$Some$0,
} from "$/gleam_stdlib/gleam/option.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  unwrapBitArrayForClone,
  wrapArrayBuffer,
} from "~/utils/bit_array.ffi.ts";

interface UnifiedWorker {
  postMessage(data: unknown): void;
  terminate(): unknown;
}

type WorkerCtor = new (
  url: string | URL,
  options?: { name?: string; type?: "module" },
) => UnifiedWorker;

const isNode = typeof globalThis.Worker === "undefined";

const WorkerCtor: WorkerCtor = isNode
  ? (await import("node:worker_threads")).Worker
  : globalThis.Worker;

// The Gleam JavaScript build emits each module under
// `build/dev/javascript/<package>/<module>.mjs`. This FFI lives at
// `build/dev/javascript/gossamer/gossamer/worker.ffi.mjs`, so its
// parent's parent is the build root.
const BUILD_ROOT = new URL("../..", import.meta.url);

export const from_module: typeof $worker.from_module = (name) => {
  const slash = name.indexOf("/");
  const packageName = slash === -1 ? name : name.slice(0, slash);
  const moduleUrl = new URL(`./${packageName}/${name}.mjs`, BUILD_ROOT).href;
  const bootstrap = `import { main } from ${
    JSON.stringify(moduleUrl)
  };\nmain();`;
  return $worker.new$(
    `data:application/javascript,${encodeURIComponent(bootstrap)}`,
  );
};

// Node's Worker constructor accepts a relative/absolute path string or a
// URL instance; it rejects bare `file://` or `data:` strings. Convert
// schemed URLs to URL instances so all forms work uniformly.
function toNodeTarget(url: string): string | URL {
  try {
    return new URL(url);
  } catch {
    return url;
  }
}

function unwrap<T>(option: Option$<T>): T | null {
  return Option$isNone(option) ? null : Option$Some$0(option);
}

function wireMessage(
  worker: UnifiedWorker,
  option: Option$<(value: unknown) => void>,
) {
  const handler = unwrap(option);
  if (!handler) return;
  if (isNode) {
    // @ts-expect-error Node's Worker uses EventEmitter `on('message', ...)`.
    worker.on("message", (data: unknown) => handler(wrapArrayBuffer(data)));
  } else {
    // @ts-expect-error globalThis.Worker has onmessage; UnifiedWorker doesn't expose it.
    worker.onmessage = (event: MessageEvent) =>
      handler(wrapArrayBuffer(event.data));
  }
}

export const build: typeof $worker.do_build = (url, name, on_message) => {
  let worker: UnifiedWorker;
  try {
    const options: { name: string; type?: "module" } = { name };
    if (!isNode) {
      options.type = "module";
    }
    worker = new WorkerCtor(isNode ? toNodeTarget(url) : url, options);
  } catch {
    return Result$Error(undefined);
  }
  wireMessage(worker, on_message);
  return Result$Ok(worker);
};

export const post_message: typeof $worker.post_message = (worker, data) => {
  try {
    worker.postMessage(unwrapBitArrayForClone(data));
    return Result$Ok(undefined);
  } catch {
    return Result$Error(undefined);
  }
};

export const terminate: typeof $worker.terminate = (worker) => {
  worker.terminate();
};
