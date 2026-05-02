import gossamer/js_error.{type JsError}

/// A JS `FinalizationRegistry` that fires cleanup callbacks after
/// registered targets are garbage collected. Callback timing is
/// non-deterministic — callbacks may fire late, or not at all if the
/// program exits before GC runs.
///
/// Targets and unregister tokens must be objects (records, lists,
/// tuples) or non-registered symbols (`gossamer/symbol.new`, not
/// `gossamer/symbol.for`); `register`, `register_with_token`, and
/// `unregister` return an error otherwise.
///
/// See [FinalizationRegistry](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/FinalizationRegistry) on MDN.
///
@external(javascript, "./finalization_registry.type.ts", "FinalizationRegistry$")
pub type FinalizationRegistry(held)

@external(javascript, "./finalization_registry.ffi.mjs", "new_")
pub fn new(callback: fn(held) -> a) -> FinalizationRegistry(held)

/// Registers `target` for cleanup, passing `held` to the callback when
/// it runs. Mutates the registry. Returns an error if `target` is
/// invalid.
///
@external(javascript, "./finalization_registry.ffi.mjs", "register")
pub fn register(
  in registry: FinalizationRegistry(held),
  target target: target,
  held held: held,
) -> Result(FinalizationRegistry(held), JsError)

/// Registers `target` for cleanup with an `unregister_token` that can
/// later be passed to `unregister` to remove the registration. Mutates
/// the registry. Returns an error if `target` or `unregister_token`
/// is invalid.
///
@external(javascript, "./finalization_registry.ffi.mjs", "register_with_token")
pub fn register_with_token(
  in registry: FinalizationRegistry(held),
  target target: target,
  held held: held,
  unregister_token token: token,
) -> Result(FinalizationRegistry(held), JsError)

/// Removes all registrations associated with `unregister_token`.
/// Mutates the registry. Returns an error if `unregister_token` is
/// invalid.
///
@external(javascript, "./finalization_registry.ffi.mjs", "unregister")
pub fn unregister(
  from registry: FinalizationRegistry(held),
  unregister_token token: token,
) -> Result(FinalizationRegistry(held), JsError)
