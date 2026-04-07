import * as $underlyingSink from "$/gossamer/gossamer/writable_stream/underlying_sink.mjs";

export function toUnderlyingSink<T>(
  options: $underlyingSink.UnderlyingSink$<T>[],
): UnderlyingSink<T> {
  const result: UnderlyingSink<T> = {};
  for (const option of options) {
    if ($underlyingSink.UnderlyingSink$isStart(option)) {
      result.start = $underlyingSink.UnderlyingSink$Start$0(option);
    } else if ($underlyingSink.UnderlyingSink$isWrite(option)) {
      result.write = $underlyingSink.UnderlyingSink$Write$0(option);
    } else if ($underlyingSink.UnderlyingSink$isClose(option)) {
      result.close = $underlyingSink.UnderlyingSink$Close$0(option);
    } else if ($underlyingSink.UnderlyingSink$isAbort(option)) {
      result.abort = $underlyingSink.UnderlyingSink$Abort$0(option);
    }
  }
  return result;
}
