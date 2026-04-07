import { type Result, Result$Error, Result$Ok } from "$/prelude.mjs";

export function toResult<T>(value: T | null | undefined): Result<T, undefined> {
  return value === null || value === undefined
    ? Result$Error(undefined)
    : Result$Ok(value);
}

toResult.fromThrows = function <T>(
  throws: () => T,
): Result<T, string> {
  try {
    return Result$Ok(throws());
  } catch (error) {
    return Result$Error(
      error instanceof Error ? error.message : String(error),
    );
  }
};

toResult.fromPromise = function <T>(
  promise: Promise<T>,
): Promise<Result<T, string>> {
  return promise.then(
    (value) => Result$Ok(value),
    (error) =>
      Result$Error(error instanceof Error ? error.message : String(error)),
  );
};
