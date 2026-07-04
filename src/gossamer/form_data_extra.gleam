//// Extensions to `gleam/fetch/form_data`.
////
//// `gleam/fetch/form_data` covers string and `BitArray` values.
//// `form_data_extra` fills the file-upload gap by attaching a `File`
//// (whose `name` becomes the multipart `Content-Disposition` filename).
//// For a raw `Blob` with a custom filename, build a `File` first via
//// `gossamer/file.from_blob(blob, named: name)`.

import gleam/fetch/form_data.{type FormData}
import gossamer/file.{type File}

/// Appends a `File` value under `key`. The multipart filename comes
/// from `file.name`. Equivalent to JavaScript's
/// `formData.append(key, file, file.name)`.
///
@external(javascript, "./form_data_extra.ffi.mjs", "append_file")
pub fn append_file(form_data: FormData, key: String, value: File) -> FormData

/// Sets `key` to a single `File` value, replacing any existing values.
/// The multipart filename comes from `file.name`. Equivalent to
/// JavaScript's `formData.set(key, file, file.name)`.
///
@external(javascript, "./form_data_extra.ffi.mjs", "set_file")
pub fn set_file(form_data: FormData, key: String, value: File) -> FormData
