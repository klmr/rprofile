check_dots_empty = function (definition = sys.function(sys.parent()), call = sys.call(sys.parent())) {
  dots = match.call(definition = definition, call = call, expand.dots = FALSE)$...
  if (length(dots) == 0L) {
    return()
  }

  stop(simpleError('`...` must be empty.\n\u2139 Did you forget to name an argument?', call))
}
