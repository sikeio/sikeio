oldMethod = $.fn.on
$.getLocal = (page_identifier)->
  $.fn.on = ->
    if typeof arguments[1] == 'string'
      arguments[1] = "." + page_identifier + " " + arguments[1]
    oldMethod.apply(this,arguments)
  return $