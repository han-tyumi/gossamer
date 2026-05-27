// Augments Web API types with fields that aren't yet in Deno's bundled
// lib. See https://github.com/denoland/deno/issues/16502 for `priority`.

type RequestPriority = "auto" | "high" | "low";

interface RequestInit {
  /** Priority hint per the Fetch spec. */
  priority?: RequestPriority;

  /** Required when `body` is a `ReadableStream`. */
  duplex?: "half";
}

interface Request {
  /** Priority hint per the Fetch spec. */
  readonly priority?: RequestPriority;
}

declare namespace Intl {
  export {};

  export interface PluralRulesOptions {
    /** ES2023 rounding strategy. */
    roundingMode?:
      | "ceil"
      | "floor"
      | "expand"
      | "trunc"
      | "halfCeil"
      | "halfFloor"
      | "halfExpand"
      | "halfTrunc"
      | "halfEven";

    /** ES2023 rounding priority. */
    roundingPriority?: "auto" | "morePrecision" | "lessPrecision";

    /** ES2023 rounding increment. */
    roundingIncrement?: number;

    /** ES2023 trailing-zero display behavior. */
    trailingZeroDisplay?: "auto" | "stripIfInteger";
  }

  export interface PluralRules {
    /** ES2023 plural-rule selection for a range. */
    selectRange(start: number | bigint, end: number | bigint): LDMLPluralRule;
  }

  export interface ResolvedPluralRulesOptions {
    /** ES2023 rounding strategy. */
    roundingMode:
      | "ceil"
      | "floor"
      | "expand"
      | "trunc"
      | "halfCeil"
      | "halfFloor"
      | "halfExpand"
      | "halfTrunc"
      | "halfEven";

    /** ES2023 rounding priority. */
    roundingPriority: "auto" | "morePrecision" | "lessPrecision";

    /** ES2023 rounding increment. */
    roundingIncrement: number;

    /** ES2023 trailing-zero display behavior. */
    trailingZeroDisplay: "auto" | "stripIfInteger";
  }
}
