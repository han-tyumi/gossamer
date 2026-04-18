// TODO: Untested — requires a byte stream (UnderlyingSource with type: "bytes")
// which gossamer doesn't expose yet. Add tests once byte stream support lands.

import gossamer/array_buffer.{type ArrayBufferView}
import gossamer/promise.{type Promise}
import gossamer/readable_stream/read_result.{type ReadResult}

@external(javascript, "./byob_reader.type.ts", "ByobReader$")
pub type ByobReader(a)

pub type ByobReaderReadOption {
  Min(Int)
}

@external(javascript, "./byob_reader.ffi.mjs", "closed")
pub fn closed(of reader: ByobReader(a)) -> Promise(Result(Nil, String))

@external(javascript, "./byob_reader.ffi.mjs", "cancel")
pub fn cancel(
  reader: ByobReader(a),
  reason reason: r,
) -> Promise(Result(Nil, String))

@external(javascript, "./byob_reader.ffi.mjs", "read")
pub fn read(
  reader: ByobReader(a),
  into view: ArrayBufferView,
  with options: List(ByobReaderReadOption),
) -> Promise(Result(ReadResult(ArrayBufferView), String))

@external(javascript, "./byob_reader.ffi.mjs", "release_lock")
pub fn release_lock(reader: ByobReader(a)) -> Result(ByobReader(a), String)
