import gossamer/blob.{type Blob}
import gossamer/file.{type File}
import gleam/option.{type Option}

@external(javascript, "./form_data.ffi.ts", "FormData$")
pub type FormData

@external(javascript, "./form_data.ffi.mjs", "new_")
pub fn new() -> FormData

@external(javascript, "./form_data.ffi.mjs", "append")
pub fn append(form_data: FormData, name: String, value: String) -> FormData

@external(javascript, "./form_data.ffi.mjs", "append_blob")
pub fn append_blob(form_data: FormData, name: String, value: Blob) -> FormData

@external(javascript, "./form_data.ffi.mjs", "append_blob_with_filename")
pub fn append_blob_with_filename(
  form_data: FormData,
  name: String,
  value: Blob,
  filename: String,
) -> FormData

@external(javascript, "./form_data.ffi.mjs", "delete_")
pub fn delete(form_data: FormData, name: String) -> FormData

@external(javascript, "./form_data.ffi.mjs", "get")
pub fn get(form_data: FormData, name: String) -> Option(String)

@external(javascript, "./form_data.ffi.mjs", "get_file")
pub fn get_file(form_data: FormData, name: String) -> Option(File)

@external(javascript, "./form_data.ffi.mjs", "get_all")
pub fn get_all(form_data: FormData, name: String) -> List(String)

@external(javascript, "./form_data.ffi.mjs", "get_all_files")
pub fn get_all_files(form_data: FormData, name: String) -> List(File)

@external(javascript, "./form_data.ffi.mjs", "has")
pub fn has(form_data: FormData, name: String) -> Bool

@external(javascript, "./form_data.ffi.mjs", "set")
pub fn set(form_data: FormData, name: String, value: String) -> FormData

@external(javascript, "./form_data.ffi.mjs", "set_blob")
pub fn set_blob(form_data: FormData, name: String, value: Blob) -> FormData

@external(javascript, "./form_data.ffi.mjs", "set_blob_with_filename")
pub fn set_blob_with_filename(
  form_data: FormData,
  name: String,
  value: Blob,
  filename: String,
) -> FormData

@external(javascript, "./form_data.ffi.mjs", "keys")
pub fn keys(form_data: FormData) -> List(String)

@external(javascript, "./form_data.ffi.mjs", "values")
pub fn values(form_data: FormData) -> List(String)

@external(javascript, "./form_data.ffi.mjs", "entries")
pub fn entries(form_data: FormData) -> List(#(String, String))

@external(javascript, "./form_data.ffi.mjs", "for_each")
pub fn for_each(form_data: FormData, callback: fn(String, String) -> Nil) -> Nil
