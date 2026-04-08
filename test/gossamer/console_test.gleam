import gossamer/console

pub fn log_test() {
  console.log("test message")
}

pub fn debug_test() {
  console.debug("debug message")
}

pub fn info_test() {
  console.info("info message")
}

pub fn warn_test() {
  console.warn("warn message")
}

pub fn error_test() {
  console.error("error message")
}

pub fn dir_test() {
  console.dir("dir item")
}

pub fn table_test() {
  console.table(42)
}

pub fn assert_true_test() {
  console.assert_(True, "should not print")
}

pub fn assert_false_test() {
  console.assert_(False, "assertion failed")
}

pub fn count_test() {
  console.count("test-label")
  console.count("test-label")
  console.count_reset("test-label")
}

pub fn group_test() {
  console.group("test-group")
  console.log("inside group")
  console.group_end()
}

pub fn group_collapsed_test() {
  console.group_collapsed("collapsed-group")
  console.group_end()
}

pub fn time_test() {
  console.time("timer")
  console.time_log("timer")
  console.time_end("timer")
}

pub fn trace_test() {
  console.trace()
}

pub fn clear_test() {
  console.clear()
}
