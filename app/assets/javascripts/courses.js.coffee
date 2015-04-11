$ ->
  eventPrefix = '.courses-page'
  $ = jQuery.getLocal(eventPrefix)

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
###
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
  #info page
  eventPrefix = '.courses-page.info'
  $= jQuery.getLocal(eventPrefix)

  $enroll = $('.enroll-panel')
  $success = $('.success-panel')
  $overlay = $('<div>').css
                position: 'fixed',
                top: '0',
                left: '0',
                width: "100%",
                height: "100%",
                background: "rgba(0,0,0,0.6)",
              .appendTo('body').hide()

  showPanel = ($panel)->
    $overlay.show()
    $panel.show()
  hidePanel = ($panel)->
    $overlay.hide()
    $panel.hide()

  $(document)
    .on 'ajax:beforeSend','.enroll-form',(evt,xhr,settings)->
      name = $(this).find('[name=name]').val()
      email = $(this).find('[name=email]').val()
      if name == "" || email == ""
        swal
          title: "名称和电子邮件不能为空~"
          type: 'error'
        return false
      else
        courseId = $('.data-course-id').text()
        settings.data += "&course_id=#{courseId}"


    .on 'ajax:success','.enroll-form',->
      hidePanel($enroll)
      showPanel($success)
    .on 'ajax:error',(evt,xhr,error)->
      msg = xhr.responseJSON.msg
      text = if Array.isArray(msg) then msg.join("\n") else msg
      swal
        title: error
        text: text
        type: 'error'

    .on 'click','#enroll',->
      $.ajax
        url: '/api/login_status'
        success: (data)->
          if data.login
            $.ajax
              url: '/enrollments'
              type: 'POST'
              data:
                courseId: $('.data-course-id').text()
              success: ->
                showPanel($success)
          else
            showPanel($enroll)
      return false

    .on 'click', '.panel', (e)->
      panel = $('.panel:visible')
      x = e.offsetX
      y = e.offsetY
      if  x < 0 || x > panel.outerWidth() || y < 0 || y > panel.outerHeight()
        hidePanel panel
