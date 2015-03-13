$ ->
  page_identifier = 'courses-page'
  $ = jQuery.getLocal(page_identifier)

  $(document)
    .ready ->
      getClock = ->
        date = new Date
        send_day = Number.parseInt($("#send-day").val())
        day_left = $("#day_left").val()
        day_left -= 1 if (send_day != date.getDate())
        if day_left >= 0
          hour = 24 * day_left - date.getHours() - 1 
          min = 60 - date.getMinutes() - 1
          sec = 60 - date.getSeconds() - 1
          $(".time").html("" + hour + "h " + min + "m " + sec + "s")
        else
          day_left = - day_left
          hour = 24 * day_left + date.getHours()
          min = date.getMinutes()
          sec = date.getSeconds()
          $(".time-remaining").html("超出时间<p class='time'>" + hour + "h " + min + "m " + sec + "s</p>") 
      setInterval(getClock, 1000)
  
