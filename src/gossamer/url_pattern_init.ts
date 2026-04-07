import * as $urlPatternInit from "$/gossamer/gossamer/url_pattern_init.mjs";

export function toURLPatternInit(
  options: $urlPatternInit.URLPatternInit$[],
): URLPatternInit {
  const result: URLPatternInit = {};
  for (const option of options) {
    if ($urlPatternInit.URLPatternInit$isProtocol(option)) {
      result.protocol = $urlPatternInit.URLPatternInit$Protocol$0(option);
    } else if ($urlPatternInit.URLPatternInit$isUsername(option)) {
      result.username = $urlPatternInit.URLPatternInit$Username$0(option);
    } else if ($urlPatternInit.URLPatternInit$isPassword(option)) {
      result.password = $urlPatternInit.URLPatternInit$Password$0(option);
    } else if ($urlPatternInit.URLPatternInit$isHostname(option)) {
      result.hostname = $urlPatternInit.URLPatternInit$Hostname$0(option);
    } else if ($urlPatternInit.URLPatternInit$isPort(option)) {
      result.port = $urlPatternInit.URLPatternInit$Port$0(option);
    } else if ($urlPatternInit.URLPatternInit$isPathname(option)) {
      result.pathname = $urlPatternInit.URLPatternInit$Pathname$0(option);
    } else if ($urlPatternInit.URLPatternInit$isSearch(option)) {
      result.search = $urlPatternInit.URLPatternInit$Search$0(option);
    } else if ($urlPatternInit.URLPatternInit$isHash(option)) {
      result.hash = $urlPatternInit.URLPatternInit$Hash$0(option);
    } else if ($urlPatternInit.URLPatternInit$isBaseURL(option)) {
      result.baseURL = $urlPatternInit.URLPatternInit$BaseURL$0(option);
    }
  }
  return result;
}
