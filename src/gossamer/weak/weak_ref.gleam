import gossamer/weak.{type WeakKeyError}

/// A JavaScript `WeakRef` whose target is weakly held — the target is
/// eligible for GC once it has no other references.
///
/// Targets must be objects (records, lists, tuples) or non-registered
/// symbols (those not in the global registry); `new` returns
/// `InvalidTarget` otherwise.
///
/// `deref` may continue to return `Ok` for some time after all other
/// references to the target are dropped — GC timing is non-deterministic.
///
/// See [WeakRef](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef) on MDN.
///
@external(javascript, "./weak_ref.type.ts", "WeakRef$")
pub type WeakRef(target)

/// Returns `InvalidTarget` if `target` is not a valid weak key.
///
@external(javascript, "./weak_ref.ffi.mjs", "new_")
pub fn new(target: target) -> Result(WeakRef(target), WeakKeyError)

/// Returns the target, or an error if it has been collected.
///
@external(javascript, "./weak_ref.ffi.mjs", "deref")
pub fn deref(ref: WeakRef(target)) -> Result(target, Nil)
