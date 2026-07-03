// Augments Web API types with fields that aren't yet in Deno's bundled lib.

interface RequestInit {
  /** Required when `body` is a `ReadableStream`. */
  duplex?: "half";
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
