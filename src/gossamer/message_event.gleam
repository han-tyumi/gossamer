import gleam/dynamic.{type Dynamic}

@external(javascript, "./message_event.type.ts", "MessageEvent$")
pub type MessageEvent

@external(javascript, "./message_event.ffi.mjs", "data")
pub fn data(event: MessageEvent) -> Dynamic

@external(javascript, "./message_event.ffi.mjs", "origin")
pub fn origin(event: MessageEvent) -> String

@external(javascript, "./message_event.ffi.mjs", "last_event_id")
pub fn last_event_id(event: MessageEvent) -> String
