import * as $eventTarget from "$/gossamer/gossamer/event_target.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function toListenerOption(
  options: $eventTarget.ListenerOption$[],
): AddEventListenerOptions {
  const result: AddEventListenerOptions = {};
  for (const option of options) {
    if ($eventTarget.ListenerOption$isCapture(option)) {
      result.capture = $eventTarget.ListenerOption$Capture$0(option);
    } else if ($eventTarget.ListenerOption$isOnce(option)) {
      result.once = $eventTarget.ListenerOption$Once$0(option);
    } else if ($eventTarget.ListenerOption$isPassive(option)) {
      result.passive = $eventTarget.ListenerOption$Passive$0(option);
    } else if ($eventTarget.ListenerOption$isSignal(option)) {
      result.signal = $eventTarget.ListenerOption$Signal$0(option);
    }
  }
  return result;
}

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
  return toResult.fromThrows(() => target.dispatchEvent(event));
};
