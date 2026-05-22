import type * as $messageChannel from "$/gossamer/gossamer/message_channel.mjs";

export const new_: typeof $messageChannel.new$ = () => {
  const channel = new MessageChannel();
  return [channel.port1, channel.port2];
};
