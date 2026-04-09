import * as $option from "$/gossamer/gossamer/event_target/listener_option.mjs";

export function toListenerOption(
  options: $option.ListenerOption$[],
): AddEventListenerOptions {
  const result: AddEventListenerOptions = {};
  for (const option of options) {
    if ($option.ListenerOption$isCapture(option)) {
      result.capture = $option.ListenerOption$Capture$0(option);
    } else if ($option.ListenerOption$isOnce(option)) {
      result.once = $option.ListenerOption$Once$0(option);
    } else if ($option.ListenerOption$isPassive(option)) {
      result.passive = $option.ListenerOption$Passive$0(option);
    } else if ($option.ListenerOption$isSignal(option)) {
      result.signal = $option.ListenerOption$Signal$0(option);
    }
  }
  return result;
}
