import * as $messageEvent from "$/gossamer/gossamer/message_event.mjs";

export const to_fields: typeof $messageEvent.to_fields = (event) => {
  return $messageEvent.Fields$Fields(
    event.data,
    event.origin,
    event.lastEventId,
  );
};

export const data: typeof $messageEvent.data = (event) => {
  return event.data;
};

export const origin: typeof $messageEvent.origin = (event) => {
  return event.origin;
};

export const last_event_id: typeof $messageEvent.last_event_id = (event) => {
  return event.lastEventId;
};
