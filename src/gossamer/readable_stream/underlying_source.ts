import * as $underlyingSource from "$/gossamer/gossamer/readable_stream/underlying_source.mjs";

export function toUnderlyingSource<T>(
  options: $underlyingSource.UnderlyingSource$<T>[],
): UnderlyingDefaultSource<T> {
  const result: UnderlyingDefaultSource<T> = {};
  for (const option of options) {
    if ($underlyingSource.UnderlyingSource$isStart(option)) {
      result.start = $underlyingSource.UnderlyingSource$Start$0(option);
    } else if ($underlyingSource.UnderlyingSource$isPull(option)) {
      result.pull = $underlyingSource.UnderlyingSource$Pull$0(option);
    } else if ($underlyingSource.UnderlyingSource$isCancel(option)) {
      result.cancel = $underlyingSource.UnderlyingSource$Cancel$0(option);
    }
  }
  return result;
}
