import * as $textDecoderOption from "$/gossamer/gossamer/text_decoder/text_decoder_option.mjs";
import type { List } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ts";

export function toTextDecoderOptions(
  options: List<$textDecoderOption.TextDecoderOption$>,
): Partial<TextDecoderOptions> {
  const result: Partial<TextDecoderOptions> = {};
  for (const option of toArray(options)) {
    if ($textDecoderOption.TextDecoderOption$isFatal(option)) {
      result.fatal = true;
    } else if ($textDecoderOption.TextDecoderOption$isIgnoreBom(option)) {
      result.ignoreBOM = true;
    }
  }
  return result;
}
