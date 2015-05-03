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






