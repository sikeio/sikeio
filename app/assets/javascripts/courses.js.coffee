$ ->
  $('.js-uncompleted').mouseenter (e)->
    $(this).removeClass("uncompleted")
    $(this).addClass("completed")

$ ->
  $('.js-uncompleted').mouseleave (e)->
    $(this).removeClass("completed")
    $(this).addClass("uncompleted")


$ ->
  $(document)
    .ready ->
      getClock = ->
        today = new Date
        send_day = Number.parseInt($("#send-day").val())
        date = new Date(send_day)
        day_left = $("#current_lesson_day_left").val()
        delay = Number.parseInt((today - date)/(1000 * 60 * 60 * 24)) #convert to day
        real_day_left = day_left - delay
        if real_day_left > 0
          hour = 24 * real_day_left - today.getHours() - 1
          min = 60 - today.getMinutes() - 1
          sec = 60 - today.getSeconds() - 1
          $(".js-current-mission-time-remainning").html("剩余时间<p>" + hour + "h " + min + "m " + sec + "s</p>")
        else
          real_day_left = - real_day_left
          hour = today.getHours()
          min = today.getMinutes()
          sec = today.getSeconds()
          if real_day_left > 0
            $(".js-current-mission-time-remainning").html("超出时间<p class='current-mission__time-remainning__time'>" + real_day_left + "d " + hour + "h " + min + " m</p>")
          else
            $(".js-current-mission-time-remainning").html("超出时间<p class='current-mission__time-remainning__time'>" + hour + "h " + min + "m " + sec + "s</p>")
      setInterval(getClock, 1000)

$ ->
  pageIdentifier = "#courses_info "
  $(document)
    .on 'ajax:success', pageIdentifier + '.js-panel--enrolling__form', ->
      $(".js-modal").trigger("show",".js-panel--success")

$ ->
  pageIdentifier = "#courses_info"

  $(document)
    .ready ->
      timeLeft = ->
        send_day = Number.parseFloat($("#send-day").val())
        date = new Date(send_day)
        today = new Date
        delay = Number.parseInt((today - date)/(1000 * 60 * 60 * 24)) #convert to day
        day_left = $("#next_lesson_day_left").val()
        if day_left
          real_day_left = day_left - delay
          if real_day_left < 1
            $(".js-time-until-next-lesson-released").html("有新课程开放了，快刷新页面吧~")
          else
            hour = 24 * real_day_left - today.getHours() - 1
            min = 60 - today.getMinutes() - 1
            sec = 60 - today.getSeconds() - 1
            $(".js-time-until-next-lesson-released").html("下一课开放时间：" + hour + "h " + min + "m " + sec + "s")
        else
          $(".js-time-until-next-lesson-released").remove()
      setInterval(timeLeft, 1000)


