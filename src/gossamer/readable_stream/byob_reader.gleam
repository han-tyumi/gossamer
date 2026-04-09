// TODO: Untested — requires a byte stream (UnderlyingSource with type: "bytes")
// which gossamer doesn't expose yet. Add tests once byte stream support lands.

import gossamer/array_buffer_view.{type ArrayBufferView}
import gossamer/promise.{type Promise}
import gossamer/readable_stream/byob_reader_read_option.{
  type ByobReaderReadOption,
}
import gossamer/readable_stream/read_result.{type ReadResult}

@external(javascript, "./byob_reader.type.ts", "ByobReader$")
pub type ByobReader(a)

@external(javascript, "./byob_reader.ffi.mjs", "closed")
pub fn closed(of reader: ByobReader(a)) -> Promise(Nil)

@external(javascript, "./byob_reader.ffi.mjs", "cancel")
pub fn cancel(reader: ByobReader(a), reason reason: r) -> Promise(Nil)

@external(javascript, "./byob_reader.ffi.mjs", "read")
pub fn read(
  reader: ByobReader(a),
  into view: ArrayBufferView,
  with options: List(ByobReaderReadOption),
) -> Promise(ReadResult(ArrayBufferView))

@external(javascript, "./byob_reader.ffi.mjs", "release_lock")
pub fn release_lock(reader: ByobReader(a)) -> ByobReader(a)
