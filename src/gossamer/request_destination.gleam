/// The destination — the kind of resource being requested. Used by the
/// browser for security decisions; not typically set by application code.
///
pub type RequestDestination {
  Audio
  AudioWorklet
  Document
  Embed
  Empty
  Font
  Frame
  Iframe
  Image
  Json
  Manifest
  Object
  PaintWorklet
  Report
  Script
  SharedWorker
  Style
  Track
  Video
  Worker
  Xslt
  Other(String)
}
