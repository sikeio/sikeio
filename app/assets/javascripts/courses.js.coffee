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

  successHTML = """
    <img class="author" src="/assets/courses/enroll_author.png" alt="">
    <div class="say">
      <p class="top">邮件已发出，期待和你交流！我的个人微信账号是 hayeah666，有问题可以加我~</p>
    </div>
    <img src="/assets/courses/weixin.png" alt="">
    <p>微信：hayeah666</p>
  """

  enrollHTML = """
    <div class="top">
      <img src="/assets/courses/enroll_author.png" alt="">
      <div class="say">
        <p class="top">嗨~我是 Howard 很高兴认识你。我希望先了解你的技术背景和学习动机，再决定这个训练营是否能对你有帮助。</p>
        <p>请在下面留下你的邮箱，我会在 2 天内和你联系。</p>
      </div>
    </div>
    <form action="/enrollments" method='post' id="enroll-form" data-remote>
      <label>姓名</label>
      <input class="name" type="text" name='name'>
      <br>
      <label>邮箱</label>
      <input class='email' type="text" name='email'>
      <br>
      <button type="submit">申请加入</button>
    </form>
  """

  $enroll = $('<dpaneliv class="enroll-panel"></div>').html(enrollHTML)
  $success = $('<div class="success-panel">').html(successHTML)

  $(document)
    .on 'ajax:beforeSend','#enroll-form',(evt,xhr,settings)->
      name = $(this).find('.name').val()
      email = $(this).find('.email').val()
      if name == "" || email == ""
        swal
          title: "名称和电子邮件不能为空~"
          type: 'error'
      else
        courseId = $('.data-course-id').text()
        settings.data += "&course_id=#{courseId}"


    .on 'ajax:success','#enroll-form',->
      $success.appendTo('body')
      $success.show()
      $enroll.hide()
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
                $success.appendTo('body')
                $success.show()
          else
            $enroll.appendTo('body')
            $enroll.show()
      return false

    # selector is empty,this add a event listen to body
    .on 'click',"",(e)->
      x = e.offsetX
      y = e.offsetY
      [$enroll,$success].forEach (p)->
        p.hide() if x < 0 ||  x > p.width() || y < 0 || y > p.height()
