import * as $eventPhase from "$/gossamer/gossamer/event_phase.mjs";

export function fromEventPhase(phase: number): $eventPhase.EventPhase$ {
  switch (phase) {
    case Event.CAPTURING_PHASE:
      return $eventPhase.EventPhase$Capturing();
    case Event.AT_TARGET:
      return $eventPhase.EventPhase$AtTarget();
    case Event.BUBBLING_PHASE:
      return $eventPhase.EventPhase$Bubbling();
    default:
      return $eventPhase.EventPhase$None();
  }
}
