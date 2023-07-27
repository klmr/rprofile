# A barebone, zero-dependency testing framework
# Or: how *not* to write a testing framework.

.context = new.env()
.context$tests = 0L
.context$asserts = 0L
.context$failures = 0L
.context$messages = character(0L)

reg.finalizer(
  environment(),
  \(.) {
    with(
      .context, {
        cat(sprintf('\n-----\n\n  %d tests | %d assertions | %d failures\n\n', tests, asserts, failures))
        writeLines(messages)
      }
    )
    if (.context$failures > 0L) {
      quit('no', status = 1L)
    }
  },
  onexit = TRUE
)

test_case = function (name, expr) {
  self = environment()

  caller = parent.frame()

  .context$tests = .context$tests + 1L
  .context$test = new.env()
  .context$test$asserts = 0L
  .context$test$failures = 0L

  messages = list()

  cat('[', name, '] …', sep = '')
  flush(stdout())

  stdout_file = tempfile()
  stderr_file = tempfile()
  stderr_redirect = file(stderr_file, open = 'wt')
  sink(stdout_file, type = 'output')
  sink(stderr_redirect, type = 'message')

  local({
    on.exit({
      sink(type = 'output')
      sink(type = 'message')
      close(stderr_redirect)
      unlink(stdout_file)
      unlink(stderr_file)
    })

    tryCatch(
      #eval(substitute(expr), envir = caller),
      expr,
      assertion_error = function (e) {
        self$messages = c(messages, conditionMessage(e))
        .context$test$failures = 1L
      },
      expect_error = function (e) {
        self$messages = c(messages, conditionMessage(e))
        .context$test$failures = 1L
      },
      error = function (e) {
        self$messages = c(messages, paste0("Unexpected failure: ", conditionMessage(e)))
        .context$test$failures = 1L
      }
    )
  })

  .context$asserts = .context$asserts + .context$test$asserts
  .context$failures = .context$failures + .context$test$failures

  success = .context$test$failures == 0L
  status_icon = if (success) '✅' else '❌'
  if (! success) {
    messages = vapply(messages, paste, character(1L), collapse = '\n    ')
    .context$messages = c(.context$messages, paste0(name, ':\n\n  * ', messages))
  }

  cat('\r[', name, '] ', status_icon, '\n', sep = '')
}

assert = function (expr) {
  if (! expr) {
    stop(.assertion_error(deparse(substitute(expr))))
  } else {
    .log_success()
  }
}

expect_ok = function (expr) {
  call = sys.call()
  tryCatch(
    {
      expr
      .log_success()
    },
    error = function (e) {
      stop(.expect_error(paste0('Unexpected error (', conditionMessage(e), ') for:'), deparse(substitute(expr)), call))
    }
  )
}

expect_error = function (expr, regex = NULL) {
  call = sys.call()
  tryCatch(
    {
      expr
      stop(.expect_error('Expected error for:', deparse(substitute(expr)), call))
    },
    error = function (e) {
      msg = conditionMessage(e)
      if (! is.null(regex) && ! grepl(regex, msg)) {
        stop(.expect_error(paste0('Expected error, but not with message (', msg, '):'), deparse(substitute(expr)), call))
      }
      .log_success()
    }
  )
}

.log_success = function () {
  .context$test$asserts = .context$test$asserts + 1L
}

.assertion_error = function (message, call = sys.call(sys.parent())) {
  .error(paste('Assertion failure:', paste(message, collapse = '\n')), call, 'assertion_error')
}

.expect_error = function (type, message, call = sys.call(sys.parent())) {
  .error(paste(type, paste(message, collapse = '\n')), call, 'expect_error')
}

.error = function (message, call, subclass) {
  simple_error_class = c('simpleError', 'error', 'condition')
  structure(
    list(message = as.character(message), call = call), 
    class = c(subclass, simple_error_class)
  )
}
