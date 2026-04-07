import * as $fileOption from "$/gossamer/gossamer/file_option.mjs";

export function toFileOptions(
  options: $fileOption.FileOption$[],
): FilePropertyBag {
  const result: FilePropertyBag = {};
  for (const option of options) {
    if ($fileOption.FileOption$isType(option)) {
      result.type = $fileOption.FileOption$Type$0(option);
    } else if ($fileOption.FileOption$isLastModified(option)) {
      result.lastModified = $fileOption.FileOption$LastModified$0(option);
    }
  }
  return result;
}
