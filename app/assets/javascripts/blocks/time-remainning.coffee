$ ->
  $(document)
    .ready ->
      getClock = ->
        today = new Date
        send_day = Number.parseInt($("#send-day").val())
        date = new Date(send_day)
        delay = Number.parseInt((today - date)/(1000 * 60 * 60 * 24)) #convert to day
        left_days = $(".js-time-left")
        left_days.each (index)->

          time_elem = $(this).children(".current_lesson_day_left").first()

          day_left = time_elem.val()

          time_show = $(this).children("p.time-show").first()
          real_day_left = day_left - delay
          if real_day_left > 0
            hour = 24 * real_day_left - today.getHours() - 1
            min = 60 - today.getMinutes() - 1
            sec = 60 - today.getSeconds() - 1
            time_show.html("剩余时间:<span>" + hour + "h " + min + "m " + sec + "s</span>")

          else
            real_day_left = - real_day_left
            hour = today.getHours()
            min = today.getMinutes()
            sec = today.getSeconds()
            $(time_show).addClass("time-show--red")
            if real_day_left > 0
              time_show.html("超出时间:<span>" + real_day_left + "d " + hour + "h " + min + " m</span>")
            else
              time_show.html("超出时间:<span>" + hour + "h " + min + "m " + sec + "s</span>")
      setInterval(getClock, 1000)



