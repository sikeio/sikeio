
###
$ ->
  $(document)
    .ready ->
      getClock = ->
        date = new Date
        send_day = Number.parseInt($("#send-day").val())
        day_left = $("#day_left").val()
        day_left -= 1 if (send_day != date.getDate())
        if day_left > 0
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
    .on 'ajax:success', '.checkout', (e,data)->
      if !data.success
        swal
          title:"失败"
          text: data.message.join('\n')
          type: 'error'

  $('i.fa.fa-check-circle.uncompleted').click (e)->
    $('#checkout_modal').modal({
           backdrop: false
        })

  $('button.close').click (e)->
    $('#checkout_modal').modal('hide')

  $('i.fa.fa-check-circle.uncompleted').mouseenter (e)->
    $(this).css("color", "#11D146")
    $(this).css("cursor", "pointer")

  $('i.fa.fa-check-circle.uncompleted').mouseleave (e)->
    $(this).css("color", "" )
    $(this).css("cursor", "")
###

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


