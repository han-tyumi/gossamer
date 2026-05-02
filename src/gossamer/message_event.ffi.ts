import * as $messageEvent from "$/gossamer/gossamer/message_event.mjs";

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
