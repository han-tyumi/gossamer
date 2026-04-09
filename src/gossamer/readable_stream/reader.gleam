import gossamer/promise.{type Promise}
import gossamer/readable_stream/read_result.{type ReadResult}

@external(javascript, "./reader.type.ts", "Reader$")
pub type Reader(a)

@external(javascript, "./reader.ffi.mjs", "closed")
pub fn closed(of reader: Reader(a)) -> Promise(Nil)

@external(javascript, "./reader.ffi.mjs", "cancel")
pub fn cancel(reader: Reader(a), reason reason: r) -> Promise(Nil)

@external(javascript, "./reader.ffi.mjs", "read")
pub fn read(reader: Reader(a)) -> Promise(Result(ReadResult(a), String))

@external(javascript, "./reader.ffi.mjs", "release_lock")
pub fn release_lock(reader: Reader(a)) -> Reader(a)
