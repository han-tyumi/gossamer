import * as $errorEvent from "$/gossamer/gossamer/error_event.mjs";
import { toOption } from "~/utils/option.ffi.ts";

export const info: typeof $errorEvent.info = (event) => {
  return $errorEvent.Info$Info(
    event.message,
    event.filename,
    event.lineno,
    event.colno,
    toOption(event.error),
  );
};
