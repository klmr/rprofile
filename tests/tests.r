source('framework/testing.r')

test_case('`check_dots_empty`: passing arguments in dots fails', {
  f = function (...) {
    rprofile:::check_dots_empty()
  }

  expect_ok(f())
  expect_error(f(1))
  expect_error(f(x = 1))
})
