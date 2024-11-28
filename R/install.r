install = function (project  = '.', ...) {
  file = file.path(project, '.Rprofile')
  args = vapply(list(...), deparse_quoted, character(1L))

  if (any(names(args) == '')) {
    stop(sprintf('All arguments to `%s::load()` must be named', .packageName))
  }

  invalid_argnames = setdiff(names(args), setdiff(names(formals(load)), '...'))

  if (length(invalid_argnames) != 0L) {
    plural_s = if (length(invalid_argnames) > 1L) 's' else ''
    invalid = paste0('`', invalid_argnames, '`', collapse = ', ')
    stop(sprintf('Unknown `%s::load()` argument name%s: %s', .packageName, plural_s, invalid))
  }

  init_code = sprintf(
    'try(%s::load(%s), silent = TRUE)',
    .packageName,
    paste(names(args), args, sep = ' = ', collapse = ', ')
  )

  old_lines = if (file.exists(file)) readLines(file)

  if (any(grepl('^[^#]*rprofile::load\\(', old_lines))) {
    message = sprintf(
      'It looks like `%s::load()` is already being called in `%s`',
      .packageName, file
    )
    warning(message)
    return(invisible())
  }

  new_lines = c(init_code, if (length(old_lines) != 0L) c('', old_lines))
  writeLines(new_lines, file)

  message('Updated ', normalizePath(file))
}

deparse_quoted = function (expr) {
  q_expr = if (is.atomic(expr)) expr else substitute(quote(e), list(e = expr))
  deparse1(q_expr)
}
