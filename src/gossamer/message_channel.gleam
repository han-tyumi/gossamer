import gossamer/message_port.{type MessagePort}

@external(javascript, "./message_channel.type.ts", "MessageChannel$")
pub type MessageChannel

@external(javascript, "./message_channel.ffi.mjs", "new_")
pub fn new() -> MessageChannel

@external(javascript, "./message_channel.ffi.mjs", "port1")
pub fn port1(of channel: MessageChannel) -> MessagePort

@external(javascript, "./message_channel.ffi.mjs", "port2")
pub fn port2(of channel: MessageChannel) -> MessagePort
