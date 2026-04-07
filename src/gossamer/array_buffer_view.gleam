import gossamer/array_buffer.{type ArrayBuffer}

pub type ArrayBufferView {
  ArrayBufferView(buffer: ArrayBuffer, byte_length: Int, byte_offset: Int)
}
