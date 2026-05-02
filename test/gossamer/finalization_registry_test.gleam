import gossamer/finalization_registry

pub fn new_test() {
  let _ = finalization_registry.new(fn(_held) { Nil })
}

pub fn register_object_target_test() {
  let registry = finalization_registry.new(fn(_held) { Nil })
  let target = #("opaque-tuple-target")
  let assert Ok(_) =
    finalization_registry.register(registry, target: target, held: "context")
}

pub fn register_with_token_test() {
  let registry = finalization_registry.new(fn(_held) { Nil })
  let target = #("target")
  let token = #("token")
  let assert Ok(_) =
    finalization_registry.register_with_token(
      registry,
      target: target,
      held: "context",
      unregister_token: token,
    )
}

pub fn register_then_unregister_test() {
  let registry = finalization_registry.new(fn(_held) { Nil })
  let target = #("target")
  let token = #("token")
  let assert Ok(registry) =
    finalization_registry.register_with_token(
      registry,
      target: target,
      held: "context",
      unregister_token: token,
    )
  let assert Ok(_) =
    finalization_registry.unregister(registry, unregister_token: token)
}

pub fn unregister_unknown_token_test() {
  let registry = finalization_registry.new(fn(_held) { Nil })
  let token = #("never-registered")
  let assert Ok(_) =
    finalization_registry.unregister(registry, unregister_token: token)
}

pub fn register_primitive_target_errors_test() {
  let registry = finalization_registry.new(fn(_held) { Nil })
  let assert Error(_) =
    finalization_registry.register(registry, target: 42, held: "context")
}

pub fn register_with_token_primitive_target_errors_test() {
  let registry = finalization_registry.new(fn(_held) { Nil })
  let token = #("token")
  let assert Error(_) =
    finalization_registry.register_with_token(
      registry,
      target: 42,
      held: "context",
      unregister_token: token,
    )
}

pub fn register_with_token_primitive_token_errors_test() {
  let registry = finalization_registry.new(fn(_held) { Nil })
  let target = #("target")
  let assert Error(_) =
    finalization_registry.register_with_token(
      registry,
      target: target,
      held: "context",
      unregister_token: 42,
    )
}

pub fn unregister_primitive_token_errors_test() {
  let registry = finalization_registry.new(fn(_held) { Nil })
  let assert Error(_) =
    finalization_registry.unregister(registry, unregister_token: 42)
}
