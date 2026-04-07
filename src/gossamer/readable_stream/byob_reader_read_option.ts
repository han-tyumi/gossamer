import * as $byobReaderReadOption from "$/gossamer/gossamer/readable_stream/byob_reader_read_option.mjs";
import type { List } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ts";

export function toByobReaderReadOptions(
  options: List<$byobReaderReadOption.ByobReaderReadOption$>,
): Partial<ReadableStreamBYOBReaderReadOptions> {
  const result: Partial<ReadableStreamBYOBReaderReadOptions> = {};
  for (const option of toArray(options)) {
    if ($byobReaderReadOption.ByobReaderReadOption$isMin(option)) {
      result.min = $byobReaderReadOption.ByobReaderReadOption$Min$0(option);
    }
  }
  return result;
}
