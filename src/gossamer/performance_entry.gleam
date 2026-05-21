//// A single entry on the performance timeline — a mark, a measure, or
//// another runtime-recorded metric. Returned by
//// [`performance.entries`](./performance.html#entries) and the
//// `entries_*` queries, and delivered to
//// [`performance_observer`](./performance_observer.html) callbacks.
////
//// Each variant carries the spec-defined fields for its kind. The
//// base fields `name`, `start_time`, and `duration` sit at the same
//// position in every variant, so `entry.name` / `entry.start_time` /
//// `entry.duration` work without pattern matching.
////
//// Kinds gossamer hasn't bound to their own variant collapse into
//// [`OtherEntry`](#OtherEntry); read `kind` to discriminate and `raw`
//// to decode kind-specific fields via `gleam/dynamic/decode`.

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gleam/time/duration.{type Duration}

/// The kind of entry on the performance timeline. Names match the W3C
/// Performance Timeline registry; `OtherKind(value)` carries any
/// runtime-emitted kind gossamer doesn't recognize. Runtimes only emit
/// a subset — see `performance_observer.supported_entry_types`.
///
pub type Kind {
  /// User-recorded mark (`performance.mark`).
  MarkKind

  /// User-recorded measurement (`performance.measure`).
  MeasureKind

  /// Resource-loading timing (fetch on Node, Deno, Bun; browsers also
  /// emit for `<img>`, `<script>`, etc.).
  ResourceKind

  /// Document navigation timing (browsers).
  NavigationKind

  /// Paint timing — `"first-paint"` and `"first-contentful-paint"`
  /// (browsers).
  PaintKind

  /// Long-task entries — tasks blocking the main thread for more than
  /// 50ms (browsers).
  LongTaskKind

  /// Event-timing entries — input event latency (browsers).
  EventKind

  /// First-input delay entries; superseded by `EventKind` (browsers).
  FirstInputKind

  /// Largest Contentful Paint — the biggest visible element painted
  /// (browsers, Core Web Vital).
  LargestContentfulPaintKind

  /// Cumulative Layout Shift — unexpected visual shifts (browsers,
  /// Core Web Vital).
  LayoutShiftKind

  /// Long-task attribution to scripts (browsers).
  TaskAttributionKind

  /// Page visibility state changes (browsers).
  VisibilityStateKind

  /// Instrumented element rendering timing (browsers).
  ElementKind

  /// Back-forward cache restoration timing (browsers).
  BackForwardCacheRestorationKind

  /// DNS-lookup timing (Node).
  DnsKind

  /// Function-call timing from `performance.timerify` (Node).
  FunctionKind

  /// Garbage-collection timing (Node).
  GcKind

  /// HTTP-request timing for Node's legacy `http` module (Node).
  HttpKind

  /// HTTP/2 stream timing (Node).
  Http2Kind

  /// Network-socket connect timing (Node).
  NetKind

  /// Any other entry-type string the runtime exposes that this
  /// binding doesn't recognize.
  OtherKind(String)
}

/// A server-side timing entry attached to a resource by the server
/// via the `Server-Timing` HTTP header.
///
/// See [PerformanceServerTiming](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceServerTiming) on MDN.
///
pub type ServerTiming {
  ServerTiming(name: String, duration: Duration, description: String)
}

/// An entry on the performance timeline. Each variant carries the
/// fields gossamer has bound for its kind; kinds without their own
/// variant fall into [`OtherEntry`](#OtherEntry).
///
pub type PerformanceEntry {
  /// A user-recorded mark — see
  /// [`gossamer/performance/mark`](./performance/mark.html).
  MarkEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    /// User-supplied metadata attached at record time.
    detail: Option(Dynamic),
  )

  /// A user-recorded measurement — see
  /// [`gossamer/performance/measure`](./performance/measure.html).
  MeasureEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    /// User-supplied metadata attached at record time.
    detail: Option(Dynamic),
  )

  /// A resource-loading timing entry — emitted by the runtime when a
  /// fetch, script load, or other resource request completes. `name`
  /// is the resource URL. Cross-runtime support is uneven: Node emits
  /// these for `fetch`; Deno and Bun currently don't. Browsers emit
  /// for fetch, images, scripts, stylesheets, etc. All timing fields
  /// are relative to
  /// [`performance.time_origin`](./performance.html#time_origin) and
  /// default to zero when the corresponding phase wasn't measured.
  ResourceEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    /// What triggered the load (`"fetch"`, `"xmlhttprequest"`,
    /// `"img"`, `"script"`, etc.).
    initiator_type: String,
    /// The network protocol used (`"h2"`, `"http/1.1"`). `None` when
    /// the runtime didn't capture it — Node returns `undefined` even
    /// on supported `fetch` calls.
    next_hop_protocol: Option(String),
    /// When a service worker began handling the request, or zero when
    /// no service worker was involved.
    worker_start: Duration,
    /// When HTTP redirect processing began, or zero when there were
    /// no redirects.
    redirect_start: Duration,
    /// When HTTP redirect processing finished, or zero when there
    /// were no redirects.
    redirect_end: Duration,
    /// When the resource fetch began.
    fetch_start: Duration,
    /// When DNS lookup began.
    domain_lookup_start: Duration,
    /// When DNS lookup completed.
    domain_lookup_end: Duration,
    /// When TCP connection setup began.
    connect_start: Duration,
    /// When TCP connection setup (including TLS) completed.
    connect_end: Duration,
    /// When TLS handshake began, or zero for non-secure connections.
    secure_connection_start: Duration,
    /// When the runtime began sending the request.
    request_start: Duration,
    /// When the runtime began receiving the response.
    response_start: Duration,
    /// When the response was fully received.
    response_end: Duration,
    /// Total bytes received including response headers.
    transfer_size: Int,
    /// Body bytes received over the wire, before any decompression.
    encoded_body_size: Int,
    /// Body bytes after the runtime decompressed them.
    decoded_body_size: Int,
    /// HTTP status code (e.g., `200`, `404`).
    response_status: Int,
    /// MIME type from the response's `Content-Type` header. Empty
    /// string when not available.
    content_type: String,
    /// How the resource was delivered. Spec values: `"cache"`,
    /// `"navigational-prefetch"`, or `""` (normal delivery).
    delivery_type: String,
    /// Whether the resource blocked rendering of the document.
    /// Spec values: `"blocking"`, `"non-blocking"`, or `""` (not
    /// applicable). Browser-only.
    render_blocking_status: String,
    /// When the runtime began receiving the first interim response
    /// (e.g., HTTP 103 Early Hints), or zero when no interim
    /// response was sent.
    first_interim_response_start: Duration,
    /// When the runtime began receiving the final response headers,
    /// or zero when not measured.
    final_response_headers_start: Duration,
    /// Server-side timing entries attached via the `Server-Timing`
    /// HTTP header. Empty when none.
    server_timing: List(ServerTiming),
  )

  /// An entry of a kind gossamer hasn't bound to its own variant.
  OtherEntry(
    name: String,
    start_time: Duration,
    duration: Duration,
    /// The resolved [`Kind`](#Kind) tag — `OtherKind(name)` when the
    /// runtime emits a kind gossamer doesn't recognize at all.
    kind: Kind,
    /// The original JavaScript entry, for manual decoding via
    /// `gleam/dynamic/decode`.
    raw: Dynamic,
  )
}

/// Returns the [`Kind`](#Kind) tag of an entry. Useful for filtering
/// without pattern matching on the full variant.
///
pub fn kind(entry: PerformanceEntry) -> Kind {
  case entry {
    MarkEntry(..) -> MarkKind
    MeasureEntry(..) -> MeasureKind
    ResourceEntry(..) -> ResourceKind
    OtherEntry(kind:, ..) -> kind
  }
}

@internal
pub fn kind_from_name(name: String) -> Kind {
  case name {
    "mark" -> MarkKind
    "measure" -> MeasureKind
    "resource" -> ResourceKind
    "navigation" -> NavigationKind
    "paint" -> PaintKind
    "longtask" -> LongTaskKind
    "event" -> EventKind
    "first-input" -> FirstInputKind
    "largest-contentful-paint" -> LargestContentfulPaintKind
    "layout-shift" -> LayoutShiftKind
    "taskattribution" -> TaskAttributionKind
    "visibility-state" -> VisibilityStateKind
    "element" -> ElementKind
    "back-forward-cache-restoration" -> BackForwardCacheRestorationKind
    "dns" -> DnsKind
    "function" -> FunctionKind
    "gc" -> GcKind
    "http" -> HttpKind
    "http2" -> Http2Kind
    "net" -> NetKind
    other -> OtherKind(other)
  }
}

@internal
pub fn kind_to_name(kind: Kind) -> String {
  case kind {
    MarkKind -> "mark"
    MeasureKind -> "measure"
    ResourceKind -> "resource"
    NavigationKind -> "navigation"
    PaintKind -> "paint"
    LongTaskKind -> "longtask"
    EventKind -> "event"
    FirstInputKind -> "first-input"
    LargestContentfulPaintKind -> "largest-contentful-paint"
    LayoutShiftKind -> "layout-shift"
    TaskAttributionKind -> "taskattribution"
    VisibilityStateKind -> "visibility-state"
    ElementKind -> "element"
    BackForwardCacheRestorationKind -> "back-forward-cache-restoration"
    DnsKind -> "dns"
    FunctionKind -> "function"
    GcKind -> "gc"
    HttpKind -> "http"
    Http2Kind -> "http2"
    NetKind -> "net"
    OtherKind(name) -> name
  }
}
