import * as $eventInit from "$/gossamer/gossamer/event_init.mjs";

export function toEventInit(
  options: $eventInit.EventInit$[],
): EventInit {
  const result: EventInit = {};
  for (const option of options) {
    if ($eventInit.EventInit$isBubbles(option)) {
      result.bubbles = $eventInit.EventInit$Bubbles$0(option);
    } else if ($eventInit.EventInit$isCancelable(option)) {
      result.cancelable = $eventInit.EventInit$Cancelable$0(option);
    } else if ($eventInit.EventInit$isComposed(option)) {
      result.composed = $eventInit.EventInit$Composed$0(option);
    }
  }
  return result;
}
