export function null_aborted_signal(): AbortSignal {
  const controller = new AbortController();
  controller.abort(null);
  return controller.signal;
}
