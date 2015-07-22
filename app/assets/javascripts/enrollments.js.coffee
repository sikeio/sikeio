$ ->
  #invite page
  $(document)
    .on 'submit', ".js-enrollment-update-personal-info-form", ->
      if $('[name="personal_info[type]"]:checked').length == 0
        swal
          title: '请先选择你的职业~'
          type: "error"
        return false



$ ->
  #pay page
  # broken!
  pageIdentifier = "#enrollments_pay "
  $(document)
    .on 'click', pageIdentifier + '.js-start-course', ->
      if $('#have-paid').prop('checked')
        $('form').submit()
      else
        swal
          title: '请先通过支付宝付款再开始课程~'

  #   .on 'keyup', pageIdentifier + 'input.buddy-name', ->
  #     if $(this).val() != ''
  #       if $('.tuition .origin').text() == '589'
  #         $('.tuition .new').text '489'
  #         $('.tuition .origin').addClass 'u-invalid-text'
  #     else
  #       if $('.tuition .new').text() == '489'
  #         $('.tuition .new').text ''
  #         $('.tuition .origin').removeClass 'u-invalid-text'

$ ->
  #pay page
  # broken!
  pageIdentifier = "#enrollments_show "
  $(document)
    .on "ajax:success", pageIdentifier + ".js-enroll-show", (e, data) ->
      if data.success
        swal
          title: "更新成功!"
          type: "success"
          closeOnConfirm: data.url
        window.location.replace(data.url)
      else
        swal
          title: "更新失败!"
          text: data.message
          type: "error"


$ ->
  #apply page
  pageIdentifier = "#enrollments_apply "
  $(document)
    .ready ->
      autoSave = ->
        autosave = $(pageIdentifier + "input#autosave").val()
        if autosave == true.toString()
          form = $(pageIdentifier + "form")
          name = form.find("input[name='user[name]']").val()
          introduce = form.find("textarea[name='user[introduce]']").val()
          token = $(pageIdentifier + "input#token").val()
          $.post "/users/autosave", {token: token, user: {name: name, introduce: introduce}}, () ->
            $(pageIdentifier + "#autosave-tips").html("已保存")

      setInterval(autoSave, 10000)
