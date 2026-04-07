import * as $responseInit from "$/gossamer/gossamer/response_init.mjs";

export function toResponseInit(
  options: $responseInit.ResponseInit$[],
): ResponseInit {
  const result: ResponseInit = {};
  for (const option of options) {
    if ($responseInit.ResponseInit$isHeaders(option)) {
      result.headers = $responseInit.ResponseInit$Headers$0(option);
    } else if ($responseInit.ResponseInit$isStatus(option)) {
      result.status = $responseInit.ResponseInit$Status$0(option);
    } else if ($responseInit.ResponseInit$isStatusText(option)) {
      result.statusText = $responseInit.ResponseInit$StatusText$0(option);
    }
  }
  return result;
}
