/// A `CloseEvent` represents an event that occurs when a `WebSocket`
/// connection is closed.
///
pub type CloseEvent {
  CloseEvent(
    /// Returns the WebSocket connection close code provided by the server.
    ///
    code: Int,
    /// Returns the WebSocket connection close reason provided by the server.
    ///
    reason: String,
    /// Returns true if the connection closed cleanly; false otherwise.
    ///
    was_clean: Bool,
  )
}
