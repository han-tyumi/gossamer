import gleam/dynamic
import gleam/int
import gleam/option.{None}
import gleeunit/should
import gossamer/async_iterator
import gossamer/iterator_result
import gossamer/promise
import gossamer/readable_stream
import gossamer/readable_stream/default_controller
import gossamer/readable_stream/read_result
import gossamer/readable_stream/reader
import gossamer/readable_stream/underlying_source
import gossamer/transform_stream
import gossamer/transform_stream/default_controller as transform_controller
import gossamer/transform_stream/transformer
import gossamer/writable_stream
import gossamer/writable_stream/default_controller as writable_controller
import gossamer/writable_stream/underlying_sink
import gossamer/writable_stream/writer

pub fn readable_stream_from_start_test() {
  let stream =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, "hello")
      default_controller.enqueue(controller, "world")
      default_controller.close(controller)
    })

  let reader = readable_stream.get_reader(stream)

  use result <- promise.then(reader.read(reader))
  should.equal(result, Ok(read_result.Value("hello")))

  use result <- promise.then(reader.read(reader))
  should.equal(result, Ok(read_result.Value("world")))

  use result <- promise.then(reader.read(reader))
  should.equal(result, Ok(read_result.Done(None)))
}

pub fn readable_stream_new_with_options_test() {
  let stream =
    readable_stream.new([
      underlying_source.Start(fn(controller) {
        default_controller.enqueue(controller, 42)
        default_controller.close(controller)
      }),
    ])

  let reader = readable_stream.get_reader(stream)

  use result <- promise.then(reader.read(reader))
  should.equal(result, Ok(read_result.Value(42)))
}

pub fn writable_stream_from_write_test() {
  let stream =
    writable_stream.from_write(fn(chunk, _controller) {
      should.equal(chunk, "hello")
      promise.resolve(Nil)
    })

  let w = writable_stream.get_writer(stream)

  use _ <- promise.then(writer.write(w, "hello"))
  use _ <- promise.then(writer.close(w))
  promise.resolve(Nil)
}

pub fn writable_stream_new_with_options_test() {
  let stream =
    writable_stream.new([
      underlying_sink.Write(fn(chunk, _controller) {
        should.equal(chunk, "test")
        promise.resolve(Nil)
      }),
    ])

  let w = writable_stream.get_writer(stream)

  use _ <- promise.then(writer.write(w, "test"))
  use _ <- promise.then(writer.close(w))
  promise.resolve(Nil)
}

pub fn transform_stream_from_transform_test() {
  let transform =
    transform_stream.from_transform(fn(chunk: Int, controller) {
      transform_controller.enqueue(controller, int.to_string(chunk))
      promise.resolve(Nil)
    })

  let readable =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, 1)
      default_controller.enqueue(controller, 2)
      default_controller.close(controller)
    })

  let transformed =
    readable_stream.pipe_through(
      readable,
      #(
        transform_stream.readable(transform),
        transform_stream.writable(transform),
      ),
      [],
    )

  let reader = readable_stream.get_reader(transformed)

  use result <- promise.then(reader.read(reader))
  should.equal(result, Ok(read_result.Value("1")))

  use result <- promise.then(reader.read(reader))
  should.equal(result, Ok(read_result.Value("2")))

  use result <- promise.then(reader.read(reader))
  should.equal(result, Ok(read_result.Done(None)))
}

pub fn readable_pipe_to_writable_test() {
  let readable =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, "a")
      default_controller.enqueue(controller, "b")
      default_controller.close(controller)
    })

  let chunks = []

  let writable =
    writable_stream.from_write(fn(chunk, _controller) {
      // Can't mutate chunks in Gleam, just verify type works.
      let _ = [chunk, ..chunks]
      promise.resolve(Nil)
    })

  use _ <- promise.then(readable_stream.pipe_to(readable, writable, []))
  promise.resolve(Nil)
}

pub fn readable_stream_is_locked_test() {
  let stream =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, "x")
      default_controller.close(controller)
    })
  readable_stream.is_locked(stream) |> should.be_false

  let r = readable_stream.get_reader(stream)
  readable_stream.is_locked(stream) |> should.be_true

  // Drain so the stream closes cleanly.
  use _ <- promise.then(reader.read(r))
  use _ <- promise.then(reader.read(r))
  promise.resolve(Nil)
}

pub fn readable_stream_tee_test() {
  let stream =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, "hello")
      default_controller.close(controller)
    })

  let #(branch1, branch2) = readable_stream.tee(stream)

  let reader1 = readable_stream.get_reader(branch1)
  let reader2 = readable_stream.get_reader(branch2)

  use result1 <- promise.then(reader.read(reader1))
  should.equal(result1, Ok(read_result.Value("hello")))

  use result2 <- promise.then(reader.read(reader2))
  should.equal(result2, Ok(read_result.Value("hello")))
  promise.resolve(Nil)
}

pub fn readable_stream_cancel_test() {
  let stream =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, "data")
      default_controller.close(controller)
    })

  use _ <- promise.then(readable_stream.cancel(stream, "done"))
  promise.resolve(Nil)
}

pub fn readable_stream_from_pull_test() {
  let stream =
    readable_stream.from_pull(fn(controller) {
      default_controller.enqueue(controller, 42)
      default_controller.close(controller)
      promise.resolve(Nil)
    })

  let r = readable_stream.get_reader(stream)

  use result <- promise.then(reader.read(r))
  should.equal(result, Ok(read_result.Value(42)))
  promise.resolve(Nil)
}

pub fn writable_stream_is_locked_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })
  writable_stream.is_locked(stream) |> should.be_false

  let w = writable_stream.get_writer(stream)
  writable_stream.is_locked(stream) |> should.be_true

  writer.release_lock(w)
}

pub fn writable_stream_close_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  use _ <- promise.then(writable_stream.close(stream))
  promise.resolve(Nil)
}

pub fn writable_stream_abort_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  use _ <- promise.then(writable_stream.abort(stream, "cancelled"))
  promise.resolve(Nil)
}

pub fn reader_release_lock_test() {
  let stream =
    readable_stream.from_start(fn(controller) {
      default_controller.close(controller)
    })

  let r = readable_stream.get_reader(stream)
  readable_stream.is_locked(stream) |> should.be_true

  reader.release_lock(r)
  readable_stream.is_locked(stream) |> should.be_false
}

pub fn writer_release_lock_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let w = writable_stream.get_writer(stream)
  writable_stream.is_locked(stream) |> should.be_true

  writer.release_lock(w)
  writable_stream.is_locked(stream) |> should.be_false
}

// Reader sub-module tests

pub fn reader_closed_test() {
  let stream =
    readable_stream.from_start(fn(controller) {
      default_controller.close(controller)
    })

  let r = readable_stream.get_reader(stream)

  // Reading past the end triggers closed.
  use _ <- promise.then(reader.read(r))
  use _ <- promise.then(reader.closed(r))
  promise.resolve(Nil)
}

pub fn reader_cancel_test() {
  let stream =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, "data")
      default_controller.close(controller)
    })

  let r = readable_stream.get_reader(stream)

  use _ <- promise.then(reader.cancel(r, "no longer needed"))
  promise.resolve(Nil)
}

// Readable default_controller sub-module tests

pub fn readable_controller_desired_size_test() {
  let stream =
    readable_stream.new([
      underlying_source.Start(fn(controller) {
        let assert Ok(size) = default_controller.desired_size(controller)
        should.be_true(size >= 0)
        default_controller.close(controller)
      }),
    ])

  let r = readable_stream.get_reader(stream)

  use _ <- promise.then(reader.read(r))
  promise.resolve(Nil)
}

// Writer sub-module tests

pub fn writer_closed_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let w = writable_stream.get_writer(stream)

  use _ <- promise.then(writer.close(w))
  use _ <- promise.then(writer.closed(w))
  promise.resolve(Nil)
}

pub fn writer_desired_size_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let w = writable_stream.get_writer(stream)
  let assert Ok(size) = writer.desired_size(w)
  should.be_true(size >= 0)
  writer.release_lock(w)
}

pub fn writer_ready_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let w = writable_stream.get_writer(stream)

  use _ <- promise.then(writer.ready(w))
  writer.release_lock(w)
  promise.resolve(Nil)
}

pub fn writer_abort_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let w = writable_stream.get_writer(stream)

  use _ <- promise.then(writer.abort(w, "aborted"))
  promise.resolve(Nil)
}

// Writable default_controller sub-module tests

pub fn writable_controller_signal_test() {
  let stream =
    writable_stream.new([
      underlying_sink.Write(fn(_chunk, controller) {
        let _signal = writable_controller.signal(controller)
        promise.resolve(Nil)
      }),
    ])

  let w = writable_stream.get_writer(stream)

  use _ <- promise.then(writer.write(w, "x"))
  use _ <- promise.then(writer.close(w))
  promise.resolve(Nil)
}

pub fn writable_controller_error_test() {
  let stream =
    writable_stream.new([
      underlying_sink.Write(fn(_chunk, controller) {
        writable_controller.error(controller, dynamic.string("fail"))
        promise.resolve(Nil)
      }),
    ])

  let w = writable_stream.get_writer(stream)

  use _ <- promise.then(writer.write(w, "trigger"))
  promise.resolve(Nil)
}

// Transform default_controller sub-module tests

pub fn transform_controller_desired_size_test() {
  let transform =
    transform_stream.new([
      transformer.Transform(fn(_chunk: String, controller) {
        let _size = transform_controller.desired_size(controller)
        transform_controller.enqueue(controller, "out")
        promise.resolve(Nil)
      }),
    ])

  let readable =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, "in")
      default_controller.close(controller)
    })

  let transformed =
    readable_stream.pipe_through(
      readable,
      #(
        transform_stream.readable(transform),
        transform_stream.writable(transform),
      ),
      [],
    )

  let r = readable_stream.get_reader(transformed)

  use _ <- promise.then(reader.read(r))
  promise.resolve(Nil)
}

pub fn transform_controller_error_test() {
  let transform =
    transform_stream.new([
      transformer.Transform(fn(_chunk: String, controller) {
        transform_controller.error(
          controller,
          dynamic.string("transform error"),
        )
        promise.resolve(Nil)
      }),
    ])

  let _readable = transform_stream.readable(transform)
  let _writable = transform_stream.writable(transform)
}

pub fn transform_controller_terminate_test() {
  let transform =
    transform_stream.new([
      transformer.Transform(fn(_chunk: String, controller) {
        transform_controller.terminate(controller)
        promise.resolve(Nil)
      }),
    ])

  let readable =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, "in")
      default_controller.close(controller)
    })

  let transformed =
    readable_stream.pipe_through(
      readable,
      #(
        transform_stream.readable(transform),
        transform_stream.writable(transform),
      ),
      [],
    )

  let r = readable_stream.get_reader(transformed)

  use result <- promise.then(reader.read(r))
  should.equal(result, Ok(read_result.Done(None)))
  promise.resolve(Nil)
}

// ReadableStream.async_iterator test

pub fn readable_stream_async_iterator_test() {
  let stream =
    readable_stream.from_start(fn(controller) {
      default_controller.enqueue(controller, 1)
      default_controller.enqueue(controller, 2)
      default_controller.close(controller)
    })

  let iter = readable_stream.async_iterator(stream)

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, iterator_result.Yield(1))

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, iterator_result.Yield(2))

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, iterator_result.Return(Nil))
  promise.resolve(Nil)
}
