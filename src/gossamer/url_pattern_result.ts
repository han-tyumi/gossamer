import * as $dict from "$/gleam_stdlib/gleam/dict.mjs";
import * as $urlPatternResult from "$/gossamer/gossamer/url_pattern_result.mjs";
import { fromArray } from "~/utils/list.ts";

function toComponentResult(
  component: URLPatternComponentResult,
): $urlPatternResult.URLPatternComponentResult$ {
  const entries = Object.entries(component.groups).filter(
    (entry): entry is [string, string] => typeof entry[1] === "string",
  );
  return $urlPatternResult.URLPatternComponentResult$URLPatternComponentResult(
    component.input,
    $dict.from_list(fromArray(entries)),
  );
}

export function toURLPatternResult(
  result: URLPatternResult,
): $urlPatternResult.URLPatternResult$ {
  return $urlPatternResult.URLPatternResult$URLPatternResult(
    toComponentResult(result.protocol),
    toComponentResult(result.username),
    toComponentResult(result.password),
    toComponentResult(result.hostname),
    toComponentResult(result.port),
    toComponentResult(result.pathname),
    toComponentResult(result.search),
    toComponentResult(result.hash),
  );
}
