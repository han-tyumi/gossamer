import gleam/dynamic
import gleam/int
import gleam/javascript/promise
import gleam/option.{None, Some}
import gleam/string
import gleam/yielder
import gleeunit/should
import gossamer/abort_signal
import gossamer/iteration/async_yielder
import gossamer/stream
import gossamer/stream/readable_stream
import gossamer/stream/readable_stream/default_controller
import gossamer/stream/readable_stream/reader
import gossamer/stream/transform_stream
import gossamer/stream/transform_stream/default_controller as transform_controller
import gossamer/stream/writable_stream
import gossamer/stream/writable_stream/default_controller as writable_controller
import gossamer/stream/writable_stream/writer
import runtime

pub fn readable_stream_new_start_throws_test() {
  readable_stream.new()
  |> readable_stream.with_start(fn(_controller) { panic as "boom" })
  |> readable_stream.build
  |> should.be_error
}

pub fn writable_stream_new_start_throws_test() {
  writable_stream.new()
  |> writable_stream.with_start(fn(_controller) { panic as "boom" })
  |> writable_stream.build
  |> should.be_error
}

pub fn transform_stream_new_start_throws_test() {
  transform_stream.new()
  |> transform_stream.with_start(fn(_controller) { panic as "boom" })
  |> transform_stream.build
  |> should.be_error
}

pub fn readable_stream_from_start_throws_test() {
  readable_stream.from_start(fn(_controller) { panic as "boom" })
  |> should.be_error
}

pub fn readable_stream_from_start_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "hello")
      let _ = default_controller.enqueue(controller, "world")
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(r) = readable_stream.get_reader(stream)

  use result <- promise.await(reader.read(r))
  should.equal(result, Ok(Some("hello")))

  use result <- promise.await(reader.read(r))
  should.equal(result, Ok(Some("world")))

  use result <- promise.map(reader.read(r))
  should.equal(result, Ok(None))
}

pub fn readable_stream_build_test() {
  let assert Ok(stream) =
    readable_stream.new()
    |> readable_stream.with_start(fn(controller) {
      let _ = default_controller.enqueue(controller, 42)
      let _ = default_controller.close(controller)
      Nil
    })
    |> readable_stream.build

  let assert Ok(r) = readable_stream.get_reader(stream)

  use result <- promise.map(reader.read(r))
  should.equal(result, Ok(Some(42)))
}

pub fn writable_stream_from_write_test() {
  let stream =
    writable_stream.from_write(fn(chunk, _controller) {
      should.equal(chunk, "hello")
      Nil
    })

  let assert Ok(w) = writable_stream.get_writer(stream)

  use _ <- promise.await(writer.write(w, "hello"))
  use _ <- promise.await(writer.close(w))
  promise.resolve(Nil)
}

pub fn writable_stream_build_test() {
  let assert Ok(stream) =
    writable_stream.new()
    |> writable_stream.with_write(fn(chunk, _controller) {
      should.equal(chunk, "test")
      Nil
    })
    |> writable_stream.build

  let assert Ok(w) = writable_stream.get_writer(stream)

  use _ <- promise.await(writer.write(w, "test"))
  use _ <- promise.await(writer.close(w))
  promise.resolve(Nil)
}

pub fn transform_stream_from_transform_test() {
  let transform =
    transform_stream.from_transform(fn(chunk: Int, controller) {
      let _ = transform_controller.enqueue(controller, int.to_string(chunk))
      Nil
    })

  let assert Ok(readable) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, 1)
      let _ = default_controller.enqueue(controller, 2)
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(transformed) =
    readable_stream.pipe_through(
      readable,
      transform_stream.read_write_pair(transform),
      readable_stream.pipe_options(),
    )

  let assert Ok(r) = readable_stream.get_reader(transformed)

  use result <- promise.await(reader.read(r))
  should.equal(result, Ok(Some("1")))

  use result <- promise.await(reader.read(r))
  should.equal(result, Ok(Some("2")))

  use result <- promise.map(reader.read(r))
  should.equal(result, Ok(None))
}

pub fn readable_pipe_to_writable_test() {
  let assert Ok(readable) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "a")
      let _ = default_controller.enqueue(controller, "b")
      let _ = default_controller.close(controller)
      Nil
    })

  let chunks = []

  let writable =
    writable_stream.from_write(fn(chunk, _controller) {
      // Can't mutate chunks in Gleam, just verify type works.
      let _ = [chunk, ..chunks]
      Nil
    })

  use _ <- promise.await(readable_stream.pipe_to(
    readable,
    writable,
    readable_stream.pipe_options(),
  ))
  promise.resolve(Nil)
}

pub fn pipe_to_aborted_signal_yields_aborted_test() {
  let assert Ok(readable) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "a")
      let _ = default_controller.close(controller)
      Nil
    })
  let writable =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let signal =
    abort_signal.abort(abort_signal.Reason(dynamic.string("stop the pipe")))
  let opts =
    readable_stream.pipe_options() |> readable_stream.set_signal(signal)

  use result <- promise.await(readable_stream.pipe_to(readable, writable, opts))
  let assert Error(stream.Aborted(_)) = result
  promise.resolve(Nil)
}

pub fn readable_stream_is_locked_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "x")
      let _ = default_controller.close(controller)
      Nil
    })
  readable_stream.is_locked(stream) |> should.be_false

  let assert Ok(r) = readable_stream.get_reader(stream)
  readable_stream.is_locked(stream) |> should.be_true

  // Drain so the stream closes cleanly.
  use _ <- promise.await(reader.read(r))
  use _ <- promise.await(reader.read(r))
  promise.resolve(Nil)
}

pub fn readable_stream_tee_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "hello")
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(#(branch1, branch2)) = readable_stream.tee(stream)

  let assert Ok(reader1) = readable_stream.get_reader(branch1)
  let assert Ok(reader2) = readable_stream.get_reader(branch2)

  use result1 <- promise.await(reader.read(reader1))
  should.equal(result1, Ok(Some("hello")))

  use result2 <- promise.await(reader.read(reader2))
  should.equal(result2, Ok(Some("hello")))
  promise.resolve(Nil)
}

pub fn readable_stream_cancel_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "data")
      let _ = default_controller.close(controller)
      Nil
    })

  use _ <- promise.await(readable_stream.cancel(stream, "done"))
  promise.resolve(Nil)
}

pub fn readable_stream_from_pull_test() {
  let stream =
    readable_stream.from_pull(fn(controller) {
      let _ = default_controller.enqueue(controller, 42)
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(r) = readable_stream.get_reader(stream)

  use result <- promise.await(reader.read(r))
  should.equal(result, Ok(Some(42)))
  promise.resolve(Nil)
}

pub fn writable_stream_is_locked_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })
  writable_stream.is_locked(stream) |> should.be_false

  let assert Ok(w) = writable_stream.get_writer(stream)
  writable_stream.is_locked(stream) |> should.be_true

  writer.release_lock(w)
  Nil
}

pub fn writable_stream_close_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  use _ <- promise.await(writable_stream.close(stream))
  promise.resolve(Nil)
}

pub fn writable_stream_abort_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  use _ <- promise.await(writable_stream.abort(stream, "cancelled"))
  promise.resolve(Nil)
}

pub fn reader_release_lock_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(r) = readable_stream.get_reader(stream)
  readable_stream.is_locked(stream) |> should.be_true

  reader.release_lock(r)
  readable_stream.is_locked(stream) |> should.be_false
}

pub fn writer_release_lock_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let assert Ok(w) = writable_stream.get_writer(stream)
  writable_stream.is_locked(stream) |> should.be_true

  writer.release_lock(w)
  writable_stream.is_locked(stream) |> should.be_false
}

pub fn reader_closed_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(r) = readable_stream.get_reader(stream)

  // Reading past the end triggers closed.
  use _ <- promise.await(reader.read(r))
  use _ <- promise.await(reader.closed(r))
  promise.resolve(Nil)
}

pub fn reader_cancel_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "data")
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(r) = readable_stream.get_reader(stream)

  use _ <- promise.await(reader.cancel(r, "no longer needed"))
  promise.resolve(Nil)
}

pub fn readable_controller_desired_size_test() {
  let assert Ok(stream) =
    readable_stream.new()
    |> readable_stream.with_start(fn(controller) {
      let assert Ok(stream.Bounded(size)) =
        default_controller.desired_size(controller)
      should.be_true(size >= 0)
      let _ = default_controller.close(controller)
      Nil
    })
    |> readable_stream.build

  let assert Ok(r) = readable_stream.get_reader(stream)

  use _ <- promise.await(reader.read(r))
  promise.resolve(Nil)
}

pub fn writer_closed_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let assert Ok(w) = writable_stream.get_writer(stream)

  use _ <- promise.await(writer.close(w))
  use _ <- promise.await(writer.closed(w))
  promise.resolve(Nil)
}

pub fn writer_desired_size_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let assert Ok(w) = writable_stream.get_writer(stream)
  let assert Ok(stream.Bounded(size)) = writer.desired_size(w)
  should.be_true(size >= 0)
  writer.release_lock(w)
  Nil
}

pub fn writer_ready_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let assert Ok(w) = writable_stream.get_writer(stream)

  use _ <- promise.await(writer.ready(w))
  writer.release_lock(w)
  promise.resolve(Nil)
}

pub fn writer_abort_test() {
  let stream =
    writable_stream.from_write(fn(_chunk, _controller) { promise.resolve(Nil) })

  let assert Ok(w) = writable_stream.get_writer(stream)

  use _ <- promise.await(writer.abort(w, "aborted"))
  promise.resolve(Nil)
}

pub fn writable_controller_signal_test() {
  let assert Ok(stream) =
    writable_stream.new()
    |> writable_stream.with_write(fn(_chunk, controller) {
      let _signal = writable_controller.signal(controller)
      Nil
    })
    |> writable_stream.build

  let assert Ok(w) = writable_stream.get_writer(stream)

  use _ <- promise.await(writer.write(w, "x"))
  use _ <- promise.await(writer.close(w))
  promise.resolve(Nil)
}

pub fn writable_controller_error_test() {
  let assert Ok(stream) =
    writable_stream.new()
    |> writable_stream.with_write(fn(_chunk, controller) {
      writable_controller.error(controller, dynamic.string("fail"))
      Nil
    })
    |> writable_stream.build

  let assert Ok(w) = writable_stream.get_writer(stream)

  use _ <- promise.await(writer.write(w, "trigger"))
  promise.resolve(Nil)
}

pub fn transform_controller_desired_size_test() {
  let assert Ok(transform) =
    transform_stream.new()
    |> transform_stream.with_transform(fn(_chunk: String, controller) {
      let _size = transform_controller.desired_size(controller)
      let _ = transform_controller.enqueue(controller, "out")
      Nil
    })
    |> transform_stream.build

  let assert Ok(readable) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "in")
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(transformed) =
    readable_stream.pipe_through(
      readable,
      transform_stream.read_write_pair(transform),
      readable_stream.pipe_options(),
    )

  let assert Ok(r) = readable_stream.get_reader(transformed)

  use _ <- promise.await(reader.read(r))
  promise.resolve(Nil)
}

pub fn transform_controller_error_test() {
  let assert Ok(transform) =
    transform_stream.new()
    |> transform_stream.with_transform(fn(_chunk: String, controller) {
      transform_controller.error(controller, dynamic.string("transform error"))
      Nil
    })
    |> transform_stream.build

  let assert Ok(source) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "in")
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(transformed) =
    readable_stream.pipe_through(
      source,
      transform_stream.read_write_pair(transform),
      readable_stream.pipe_options(),
    )

  let assert Ok(r) = readable_stream.get_reader(transformed)

  // After Transform calls controller.error, the readable side errors out
  // and reader.read rejects.
  use result <- promise.await(reader.read(r))
  should.be_error(result)
  promise.resolve(Nil)
}

pub fn transform_controller_terminate_test() {
  let assert Ok(transform) =
    transform_stream.new()
    |> transform_stream.with_transform(fn(_chunk: String, controller) {
      let _ = transform_controller.terminate(controller)
      Nil
    })
    |> transform_stream.build

  let assert Ok(readable) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "in")
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(transformed) =
    readable_stream.pipe_through(
      readable,
      transform_stream.read_write_pair(transform),
      readable_stream.pipe_options(),
    )

  let assert Ok(r) = readable_stream.get_reader(transformed)

  use result <- promise.await(reader.read(r))
  should.equal(result, Ok(None))
  promise.resolve(Nil)
}

pub fn readable_stream_to_async_yielder_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, 1)
      let _ = default_controller.enqueue(controller, 2)
      let _ = default_controller.close(controller)
      Nil
    })

  let result =
    readable_stream.to_async_yielder(stream)
    |> async_yielder.to_list

  use result <- promise.await(result)
  should.equal(result, [1, 2])
  promise.resolve(Nil)
}

pub fn readable_stream_controlled_test() {
  let #(stream, controller) = readable_stream.controlled()
  let _ = default_controller.enqueue(controller, 1)
  let _ = default_controller.enqueue(controller, 2)
  let _ = default_controller.close(controller)

  use result <- promise.await(
    readable_stream.to_async_yielder(stream) |> async_yielder.to_list,
  )
  should.equal(result, [1, 2])
  promise.resolve(Nil)
}

pub fn read_text_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let assert Ok(_) = default_controller.enqueue(controller, <<"hello ">>)
      let assert Ok(_) = default_controller.enqueue(controller, <<"world">>)
      let assert Ok(_) = default_controller.close(controller)
      Nil
    })
  use result <- promise.await(readable_stream.read_text(stream))
  should.equal(result, Ok("hello world"))
  promise.resolve(Nil)
}

pub fn read_text_locked_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let assert Ok(_) = default_controller.enqueue(controller, <<"x">>)
      let assert Ok(_) = default_controller.close(controller)
      Nil
    })
  let assert Ok(_) = readable_stream.get_reader(stream)

  use result <- promise.await(readable_stream.read_text(stream))
  result |> should.be_error
  promise.resolve(Nil)
}

pub fn read_bytes_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let assert Ok(_) = default_controller.enqueue(controller, <<104, 105>>)
      let assert Ok(_) = default_controller.enqueue(controller, <<33>>)
      let assert Ok(_) = default_controller.close(controller)
      Nil
    })
  use result <- promise.await(readable_stream.read_bytes(stream))
  should.equal(result, Ok(<<104, 105, 33>>))
  promise.resolve(Nil)
}

pub fn read_bytes_locked_test() {
  let assert Ok(stream) =
    readable_stream.from_start(fn(controller) {
      let assert Ok(_) = default_controller.enqueue(controller, <<0>>)
      let assert Ok(_) = default_controller.close(controller)
      Nil
    })
  let assert Ok(_) = readable_stream.get_reader(stream)

  use result <- promise.await(readable_stream.read_bytes(stream))
  result |> should.be_error
  promise.resolve(Nil)
}

/// Bun doesn't implement `ReadableStream.from`. The FFI's `ensureMethod`
/// guard intercepts the missing-method call and throws a diagnostic
/// error naming the binding and the upstream issue URL.
pub fn from_yielder_bun_divergence_test() {
  use <- runtime.only_on(runtime.Bun)
  let assert Error(message) =
    runtime.catch_panic(fn() {
      readable_stream.from_yielder(yielder.from_list([1, 2, 3]))
    })
  message |> string.contains("readable_stream.from_yielder") |> should.be_true
  message
  |> string.contains("github.com/oven-sh/bun/issues/3700")
  |> should.be_true
}

pub fn from_async_yielder_bun_divergence_test() {
  use <- runtime.only_on(runtime.Bun)
  let assert Error(message) =
    runtime.catch_panic(fn() {
      readable_stream.from_async_yielder(async_yielder.from_list([1, 2, 3]))
    })
  message
  |> string.contains("readable_stream.from_async_yielder")
  |> should.be_true
  message
  |> string.contains("github.com/oven-sh/bun/issues/3700")
  |> should.be_true
}
