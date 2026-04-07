import { type Result, Result$Error, Result$Ok } from "$/prelude.mjs";

export function toResult<T, E>(
  value: T | null | undefined,
  errorValue: E,
): Result<T, E> {
  return value === null || value === undefined
    ? Result$Error(errorValue)
    : Result$Ok(value);
}

toResult.fromThrows = function <T, E>(
  throws: () => T,
  mapError: (error: unknown) => E,
): Result<T, E> {
  try {
    return Result$Ok(throws());
  } catch (error) {
    return Result$Error(mapError(error));
  }
};
