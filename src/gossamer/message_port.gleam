import gleam/dynamic.{type Dynamic}
import gossamer/message_event.{type MessageEvent}

@external(javascript, "./message_port.type.ts", "MessagePort$")
pub type MessagePort

@external(javascript, "./message_port.ffi.mjs", "post_message")
pub fn post_message(port: MessagePort, message: Dynamic) -> Nil

@external(javascript, "./message_port.ffi.mjs", "start")
pub fn start(port: MessagePort) -> Nil

@external(javascript, "./message_port.ffi.mjs", "close")
pub fn close(port: MessagePort) -> Nil

@external(javascript, "./message_port.ffi.mjs", "on_message")
pub fn on_message(port: MessagePort, handler: fn(MessageEvent) -> Nil) -> Nil

@external(javascript, "./message_port.ffi.mjs", "on_message_error")
pub fn on_message_error(
  port: MessagePort,
  handler: fn(MessageEvent) -> Nil,
) -> Nil
