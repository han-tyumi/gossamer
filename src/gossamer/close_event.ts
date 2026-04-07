import * as $closeEvent from "$/gossamer/gossamer/close_event.mjs";

export function toCloseEvent(event: CloseEvent): $closeEvent.CloseEvent$ {
  return $closeEvent.CloseEvent$CloseEvent(
    event.code,
    event.reason,
    event.wasClean,
  );
}
