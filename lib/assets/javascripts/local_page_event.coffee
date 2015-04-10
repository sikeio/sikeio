oldMethod = $.fn.on
$.getLocal = (prefix)->
  $.fn.oldOn = oldMethod
  $.fn.on = ->
    if typeof arguments[1] == 'string'
      arguments[1] = prefix + " " + arguments[1]
    oldMethod.apply(this,arguments)
  return $