import gossamer/js_error.{type JsError}

/// A JS `WeakRef` whose target is weakly held — the target is eligible
/// for GC once it has no other references.
///
/// Targets must be objects (records, lists, tuples) or non-registered
/// symbols (`gossamer/symbol.new`, not `gossamer/symbol.for`); `new`
/// returns an error otherwise.
///
/// See [WeakRef](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef) on MDN.
///
@external(javascript, "./weak_ref.type.ts", "WeakRef$")
pub type WeakRef(target)

/// Returns an error if `target` is invalid.
///
@external(javascript, "./weak_ref.ffi.mjs", "new_")
pub fn new(target: target) -> Result(WeakRef(target), JsError)

/// Returns the target, or an error if it has been collected.
///
@external(javascript, "./weak_ref.ffi.mjs", "deref")
pub fn deref(of ref: WeakRef(target)) -> Result(target, Nil)
