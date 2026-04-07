import gossamer/blob.{type Blob}

@external(javascript, "./file.type.ts", "File$")
pub type File

@external(javascript, "./file.ffi.mjs", "from_strings")
pub fn from_strings(parts: List(String), name: String) -> File

@external(javascript, "./file.ffi.mjs", "from_blob")
pub fn from_blob(blob: Blob, name: String) -> File

@external(javascript, "./file.ffi.mjs", "name")
pub fn name(file: File) -> String

@external(javascript, "./file.ffi.mjs", "last_modified")
pub fn last_modified(file: File) -> Int

@external(javascript, "./file.ffi.mjs", "to_blob")
pub fn to_blob(file: File) -> Blob
