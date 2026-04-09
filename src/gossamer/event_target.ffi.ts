import type * as $eventTarget from "$/gossamer/gossamer/event_target.mjs";
import { toListenerOption } from "~/gossamer/event_target/listener_option.ts";
import { toArray } from "~/utils/list.ts";

export type EventTarget$ = EventTarget;

export const new_: typeof $eventTarget.new$ = () => {
  return new EventTarget();
};

export const add_event_listener: typeof $eventTarget.add_event_listener = (
  target,
  type,
  listener,
) => {
  target.addEventListener(type, listener as EventListener);
};

export const add_event_listener_with:
  typeof $eventTarget.add_event_listener_with = (
    target,
    type,
    listener,
    options,
  ) => {
    target.addEventListener(
      type,
      listener as EventListener,
      toListenerOption(toArray(options)),
    );
  };

export const remove_event_listener: typeof $eventTarget.remove_event_listener =
  (target, type, listener) => {
    target.removeEventListener(type, listener as EventListener);
  };

export const remove_event_listener_with:
  typeof $eventTarget.remove_event_listener_with = (
    target,
    type,
    listener,
    options,
  ) => {
    target.removeEventListener(
      type,
      listener as EventListener,
      toListenerOption(toArray(options)),
    );
  };

export const dispatch_event: typeof $eventTarget.dispatch_event = (
  target,
  event,
) => {
  return target.dispatchEvent(event);
};
