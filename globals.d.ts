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
