import * as $readyState from "$/gossamer/gossamer/ready_state.mjs";

export function toReadyState(value: number): $readyState.ReadyState$ {
  switch (value) {
    case 0:
      return $readyState.ReadyState$Connecting();
    case 1:
      return $readyState.ReadyState$Open();
    case 2:
      return $readyState.ReadyState$Closing();
    case 3:
      return $readyState.ReadyState$Closed();
    default:
      return $readyState.ReadyState$Closed();
  }
}
