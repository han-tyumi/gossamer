import gossamer/abort_signal.{type AbortSignal}

pub type ListenerOption {
  Capture(Bool)
  Once(Bool)
  Passive(Bool)
  Signal(AbortSignal)
}
