$ ->
  page_identifier = 'home-page'
  $ = jQuery.getLocal(page_identifier)

  $(document)
    .on 'ajax:success','.subscribe',(e,data)->
      if data.success
        swal
          title: "订阅成功~"
      else
        swal
          title: '订阅失败~'
          text: data.msg.join('\n')
          type: 'error'

