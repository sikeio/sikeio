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
  $overlay = $('<div class="panel-overlay">').appendTo('body')

  $enroll = $('.js-panel--enrolling')
  $success = $('.js-panel--success')
  

  showPanel = ($panel)->
    $overlay.show()
    $panel.show()
  hidePanel = ($panel)->
    $overlay.hide()
    $panel.hide()


  # The panel actually covers the whole screen.
  $(".panel").on 'click', (e)->
    panel = $('.panel:visible')
    x = e.offsetX
    y = e.offsetY
    if  x < 0 || x > panel.outerWidth() || y < 0 || y > panel.outerHeight()
      hidePanel panel

  # not sure why it doesn't work to hook into document
  # $(document).on "click", ".js-enroll-panel-trigger", ->
  $(".js-enroll-panel-trigger").on "click", ->
    showPanel($enroll)

  $form = $(".js-panel--enrolling__form")
  $form.on 'ajax:error', (evt,xhr,error)->
      console.log("ajax error")
      msg = xhr.responseJSON.msg
      text = if Array.isArray(msg) then msg.join("\n") else msg
      swal
        title: error
        text: text
        type: 'error'

  $form.on "ajax:success", ->
    hidePanel($enroll)
    showPanel($success)

