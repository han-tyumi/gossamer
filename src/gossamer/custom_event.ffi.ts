import * as $customEvent from "$/gossamer/gossamer/custom_event.mjs";
import { toOption } from "~/utils/option.ffi.ts";

export type CustomEventRef$ = CustomEvent;

export function toCustomEvent(event: CustomEvent): $customEvent.CustomEvent$ {
  return $customEvent.CustomEvent$CustomEvent(toOption(event.detail), event);
}

function ref(event: $customEvent.CustomEvent$): CustomEvent {
  return $customEvent.CustomEvent$CustomEvent$ref(event);
}

export const new_: typeof $customEvent.new$ = (type) => {
  return toCustomEvent(new CustomEvent(type));
};

export const new_with_detail: typeof $customEvent.new_with_detail = (
  type,
  detail,
) => {
  return toCustomEvent(new CustomEvent(type, { detail }));
};

export const to_event: typeof $customEvent.to_event = (event) => {
  return ref(event) as unknown as Event;
};
