import * as $event from "$/gossamer/gossamer/event.mjs";
import { fromEventPhase } from "~/gossamer/event_phase.ts";
import { fromArray, toArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

export type Event$ = Event;

function toEventInit(options: $event.EventInit$[]): EventInit {
  const result: EventInit = {};
  for (const option of options) {
    if ($event.EventInit$isBubbles(option)) {
      result.bubbles = $event.EventInit$Bubbles$0(option);
    } else if ($event.EventInit$isCancelable(option)) {
      result.cancelable = $event.EventInit$Cancelable$0(option);
    } else if ($event.EventInit$isComposed(option)) {
      result.composed = $event.EventInit$Composed$0(option);
    }
  }
  return result;
}

export const new_: typeof $event.new$ = (type) => {
  return new Event(type);
};

export const new_with: typeof $event.new_with = (type, init) => {
  return new Event(type, toEventInit(toArray(init)));
};

export const type_: typeof $event.type_ = (event) => event.type;

export const target: typeof $event.target = (event) => {
  return toResult(event.target as EventTarget | null);
};

export const current_target: typeof $event.current_target = (event) => {
  return toResult(event.currentTarget as EventTarget | null);
};

export const event_phase: typeof $event.event_phase = (event) => {
  return fromEventPhase(event.eventPhase);
};

export const time_stamp: typeof $event.time_stamp = (event) => {
  return event.timeStamp;
};

export const is_bubbles: typeof $event.is_bubbles = (event) => event.bubbles;

export const is_cancelable: typeof $event.is_cancelable = (event) =>
  event.cancelable;

export const is_default_prevented: typeof $event.is_default_prevented = (
  event,
) => event.defaultPrevented;

export const is_composed: typeof $event.is_composed = (event) => event.composed;

export const is_trusted: typeof $event.is_trusted = (event) => event.isTrusted;

export const prevent_default: typeof $event.prevent_default = (event) => {
  event.preventDefault();
  return event;
};

export const stop_propagation: typeof $event.stop_propagation = (event) => {
  event.stopPropagation();
  return event;
};

export const stop_immediate_propagation:
  typeof $event.stop_immediate_propagation = (event) => {
    event.stopImmediatePropagation();
    return event;
  };

export const composed_path: typeof $event.composed_path = (event) => {
  return fromArray(event.composedPath() as EventTarget[]);
};
