import gossamer/blob.{type Blob}
import gossamer/file.{type File}
import gossamer/iterator.{type Iterator}

/// Represents a value stored in a `FormData` entry. Form data values are
/// either strings or files.
///
pub type FormDataValue {
  Text(String)
  FileValue(File)
}

/// A set of key/value pairs representing form fields and their values,
/// useful for building request bodies for multipart form submissions.
/// Mutable — methods modify the set in place and return it for chaining.
///
/// See [FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData) on MDN.
///
@external(javascript, "./form_data.type.ts", "FormData$")
pub type FormData

@external(javascript, "./form_data.ffi.mjs", "new_")
pub fn new() -> FormData

/// Appends a new value onto an existing key, or adds the key if it does not
/// already exist. Mutates the form data in-place and returns it for chaining.
///
@external(javascript, "./form_data.ffi.mjs", "append")
pub fn append(
  to form_data: FormData,
  name name: String,
  value value: String,
) -> FormData

/// Appends a blob value. Mutates the form data in-place and returns it for
/// chaining.
///
@external(javascript, "./form_data.ffi.mjs", "append_blob")
pub fn append_blob(
  to form_data: FormData,
  name name: String,
  value value: Blob,
) -> FormData

/// Appends a blob value with a filename. Mutates the form data in-place and
/// returns it for chaining.
///
@external(javascript, "./form_data.ffi.mjs", "append_blob_with_filename")
pub fn append_blob_with_filename(
  to form_data: FormData,
  name name: String,
  value value: Blob,
  named filename: String,
) -> FormData

/// Deletes a key and all its values. Mutates the form data in-place and
/// returns it for chaining.
///
@external(javascript, "./form_data.ffi.mjs", "delete_")
pub fn delete(from form_data: FormData, name name: String) -> FormData

/// Returns the first string value for `name`, or `Error(Nil)` if no such
/// key exists or its first value is a file.
///
@external(javascript, "./form_data.ffi.mjs", "get")
pub fn get(from form_data: FormData, name name: String) -> Result(String, Nil)

/// Returns the first file value for `name`, or `Error(Nil)` if no such key
/// exists or its first value is a string.
///
@external(javascript, "./form_data.ffi.mjs", "get_file")
pub fn get_file(
  from form_data: FormData,
  name name: String,
) -> Result(File, Nil)

@external(javascript, "./form_data.ffi.mjs", "get_all")
pub fn get_all(from form_data: FormData, name name: String) -> List(String)

@external(javascript, "./form_data.ffi.mjs", "get_all_files")
pub fn get_all_files(from form_data: FormData, name name: String) -> List(File)

@external(javascript, "./form_data.ffi.mjs", "has")
pub fn has(in form_data: FormData, name name: String) -> Bool

/// Sets a new value for an existing key, or adds the key if it does not
/// already exist. Mutates the form data in-place and returns it for chaining.
///
@external(javascript, "./form_data.ffi.mjs", "set")
pub fn set(
  in form_data: FormData,
  name name: String,
  value value: String,
) -> FormData

/// Sets a blob value. Mutates the form data in-place and returns it for
/// chaining.
///
@external(javascript, "./form_data.ffi.mjs", "set_blob")
pub fn set_blob(
  in form_data: FormData,
  name name: String,
  value value: Blob,
) -> FormData

/// Sets a blob value with a filename. Mutates the form data in-place and
/// returns it for chaining.
///
@external(javascript, "./form_data.ffi.mjs", "set_blob_with_filename")
pub fn set_blob_with_filename(
  in form_data: FormData,
  name name: String,
  value value: Blob,
  named filename: String,
) -> FormData

@external(javascript, "./form_data.ffi.mjs", "keys")
pub fn keys(of form_data: FormData) -> Iterator(String, Nil, Nil)

@external(javascript, "./form_data.ffi.mjs", "values")
pub fn values(of form_data: FormData) -> Iterator(FormDataValue, Nil, Nil)

@external(javascript, "./form_data.ffi.mjs", "entries")
pub fn entries(
  of form_data: FormData,
) -> Iterator(#(String, FormDataValue), Nil, Nil)

@external(javascript, "./form_data.ffi.mjs", "for_each")
pub fn for_each(
  in form_data: FormData,
  run callback: fn(String, FormDataValue) -> a,
) -> Nil
