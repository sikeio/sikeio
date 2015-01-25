$.getLocal = (page_identifier)->
  oldMethod = $.fn.on
  $.fn.on = ->
    arguments[1] = "." + page_identifier + " " + arguments[1]
    oldMethod.apply(this,arguments)
  return $