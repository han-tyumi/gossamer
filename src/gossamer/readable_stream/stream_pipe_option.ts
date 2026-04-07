import * as $streamPipeOption from "$/gossamer/gossamer/readable_stream/stream_pipe_option.mjs";
import type { List } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ts";

export function toStreamPipeOptions(
  options: List<$streamPipeOption.StreamPipeOption$>,
): Partial<StreamPipeOptions> {
  const result: Partial<StreamPipeOptions> = {};
  for (const option of toArray(options)) {
    if ($streamPipeOption.StreamPipeOption$isPreventAbort(option)) {
      result.preventAbort = true;
    } else if ($streamPipeOption.StreamPipeOption$isPreventCancel(option)) {
      result.preventCancel = true;
    } else if ($streamPipeOption.StreamPipeOption$isPreventClose(option)) {
      result.preventClose = true;
    } else if ($streamPipeOption.StreamPipeOption$isSignal(option)) {
      result.signal = $streamPipeOption.StreamPipeOption$Signal$0(option);
    }
  }
  return result;
}
