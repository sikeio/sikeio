$ ->
  pageID = $('body').attr('id')
  if pageID != 'users_notes' && pageID != "users_note"
    return

  $('.qrcode').each ->
    $(this).qrcode
      "render": "image"
      "size": 160
      "text": $(this).parent().data('url')

  $('.share a').click ->
    $(this).closest('.share').find('.qrcode').toggle()

  $('.edit a').click ->
    vex.dialog.open
        message: '编辑个人信息~~~'
        input: """
          <div class="form">
            <div class="form__row">
                <label for="twitter">Twitter</label>
                <input name="twitter" type="text" />
            </div>
            <div class="form__row">
                <label for="blog">Blog</label>
                <input name="blog" type="text" />
            </div>
            <div class="form__row">
                <label for="intro">自我简介</label>
                <input name="intro" type="text" />
            </div>
          </div>
        """
        callback: (data) ->
            return if data is false
            $.ajax
              url: $('.edit a').data('url')
              method: 'post'
              data:
                personal_info: data
              success: ->
                swal
                  title: "更新成功！"
                  type: "success"
                  , ->
                    location.reload()
              error: (xhr, status, error) ->
                swal
                  title: error
                  type: 'error'



