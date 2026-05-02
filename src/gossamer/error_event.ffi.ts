import * as $errorEvent from "$/gossamer/gossamer/error_event.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function toErrorEventInit(
  options: $errorEvent.ErrorEventInit$<unknown>[],
): ErrorEventInit {
  const result: ErrorEventInit = {};
  for (const option of options) {
    if ($errorEvent.ErrorEventInit$isBubbles(option)) {
      result.bubbles = $errorEvent.ErrorEventInit$Bubbles$0(option);
    } else if ($errorEvent.ErrorEventInit$isCancelable(option)) {
      result.cancelable = $errorEvent.ErrorEventInit$Cancelable$0(option);
    } else if ($errorEvent.ErrorEventInit$isComposed(option)) {
      result.composed = $errorEvent.ErrorEventInit$Composed$0(option);
    } else if ($errorEvent.ErrorEventInit$isMessage(option)) {
      result.message = $errorEvent.ErrorEventInit$Message$0(option);
    } else if ($errorEvent.ErrorEventInit$isFilename(option)) {
      result.filename = $errorEvent.ErrorEventInit$Filename$0(option);
    } else if ($errorEvent.ErrorEventInit$isLineno(option)) {
      result.lineno = $errorEvent.ErrorEventInit$Lineno$0(option);
    } else if ($errorEvent.ErrorEventInit$isColno(option)) {
      result.colno = $errorEvent.ErrorEventInit$Colno$0(option);
    } else if ($errorEvent.ErrorEventInit$isValue(option)) {
      result.error = $errorEvent.ErrorEventInit$Value$0(option);
    }
  }
  return result;
}

export const to_fields: typeof $errorEvent.to_fields = (event) => {
  return $errorEvent.Fields$Fields(
    event.message,
    event.filename,
    event.lineno,
    event.colno,
    toOption(event.error),
  );
};

export const new_: typeof $errorEvent.new$ = (type) => {
  return new ErrorEvent(type);
};

export const new_with: typeof $errorEvent.new_with = (type, init) => {
  return new ErrorEvent(type, toErrorEventInit(toArray(init)));
};

export const message: typeof $errorEvent.message = (event) => event.message;

export const filename: typeof $errorEvent.filename = (event) => event.filename;

export const lineno: typeof $errorEvent.lineno = (event) => event.lineno;

export const colno: typeof $errorEvent.colno = (event) => event.colno;

export const error: typeof $errorEvent.error = (event) => {
  return toResult(event.error);
};

export const to_event: typeof $errorEvent.to_event = (event) => {
  return event as unknown as Event;
};
