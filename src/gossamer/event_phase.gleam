/// The phase of event propagation — whether an event is currently being
/// captured, dispatched at the target, or bubbling.
///
pub type EventPhase {
  None
  Capturing
  AtTarget
  Bubbling
}
