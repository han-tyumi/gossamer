import gossamer/abort_signal.{type AbortSignal}

pub type StreamPipeOption {
  PreventAbort
  PreventCancel
  PreventClose
  Signal(AbortSignal)
}
