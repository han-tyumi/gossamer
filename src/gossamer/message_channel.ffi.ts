import type * as $messageChannel from "$/gossamer/gossamer/message_channel.mjs";

export const new_: typeof $messageChannel.new$ = () => {
  return new MessageChannel();
};

export const port1: typeof $messageChannel.port1 = (channel) => {
  return channel.port1;
};

export const port2: typeof $messageChannel.port2 = (channel) => {
  return channel.port2;
};
