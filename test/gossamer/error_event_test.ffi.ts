export function make_full(): ErrorEvent {
  return new ErrorEvent("error", {
    message: "boom",
    filename: "test.js",
    lineno: 42,
    colno: 7,
    error: new Error("inner"),
  });
}

export function make_empty(): ErrorEvent {
  return new ErrorEvent("error");
}
