import * as $customEvent from "$/gossamer/gossamer/custom_event.mjs";
import { toOption } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const to_fields: typeof $customEvent.to_fields = (event) => {
  return $customEvent.Fields$Fields(toOption(event.detail));
};

export const new_: typeof $customEvent.new$ = (type) => {
  return new CustomEvent(type);
};

export const new_with_detail: typeof $customEvent.new_with_detail = (
  type,
  detail,
) => {
  return new CustomEvent(type, { detail });
};

export const detail: typeof $customEvent.detail = (event) => {
  return toResult(event.detail);
};

export const to_event: typeof $customEvent.to_event = (event) => {
  return event as unknown as Event;
};
