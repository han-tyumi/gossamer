import gossamer/blob.{type Blob}

/// Provides information about files and allows JavaScript in a web page
/// to access their content.
///
@external(javascript, "./file.type.ts", "File$")
pub type File

/// Creates a new `File` from a list of strings.
///
@external(javascript, "./file.ffi.mjs", "from_strings")
pub fn from_strings(parts: List(String), name: String) -> File

/// Creates a new `File` from a `Blob`.
///
@external(javascript, "./file.ffi.mjs", "from_blob")
pub fn from_blob(blob: Blob, name: String) -> File

@external(javascript, "./file.ffi.mjs", "name")
pub fn name(file: File) -> String

@external(javascript, "./file.ffi.mjs", "last_modified")
pub fn last_modified(file: File) -> Int

/// Converts a `File` to a `Blob` for use with generic blob functions.
///
@external(javascript, "./file.ffi.mjs", "to_blob")
pub fn to_blob(file: File) -> Blob
