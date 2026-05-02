import * as $messageEvent from "$/gossamer/gossamer/message_event.mjs";

export type MessageEventRef$ = MessageEvent;

export function toMessageEvent(
  event: MessageEvent,
): $messageEvent.MessageEvent$ {
  return $messageEvent.MessageEvent$MessageEvent(
    event.data,
    event.origin,
    event.lastEventId,
    event,
  );
}
