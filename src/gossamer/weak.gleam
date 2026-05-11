//// Parent module for the weak collections family — `WeakRef`,
//// `WeakMap`, `WeakSet`, and `FinalizationRegistry`. Hosts
//// `WeakKeyError`, the shared error type returned when an operation
//// is passed a value that isn't a valid weak key.

/// Errors raised by weak-collection operations.
pub type WeakKeyError {
  /// The supplied value is not a valid weak key. Valid weak keys are
  /// objects (records, lists, tuples) or non-registered symbols
  /// (those not in the global registry).
  InvalidTarget
}
