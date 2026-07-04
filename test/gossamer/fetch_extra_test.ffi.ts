import { from_fetch_response } from "$/gleam_fetch/gleam/fetch.mjs";

export async function make_test_response() {
  const jsResponse = await fetch("data:text/plain,hello");
  return from_fetch_response(jsResponse);
}
