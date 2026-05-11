export function make_dom_exception(message: string, name: string): Error {
  return new DOMException(message, name);
}
