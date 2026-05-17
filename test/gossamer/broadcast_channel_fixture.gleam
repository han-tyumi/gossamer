//// Worker-side fixture used by the cross-worker BroadcastChannel
//// test. Subscribes to a broadcast channel, signals ready, then
//// echoes each broadcast back to the parent via
//// gossamer/worker_parent.

import gossamer/broadcast_channel
import gossamer/worker_parent

pub fn main() {
  let channel = broadcast_channel.new("test-channel-fanout")
  broadcast_channel.set_on_message(channel, fn(data) {
    let _ = worker_parent.post_message(data)
    Nil
  })
  let _ = worker_parent.post_message("ready")
}
