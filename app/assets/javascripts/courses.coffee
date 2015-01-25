$ ->
  page_identifier = 'courses-page'
  $ = jQuery.getLocal(page_identifier)

  $(document)
    .on 'ajax:success','form.enroll',(event,data)->
      #if server returns js ,jquery ujs will exec it
      return if (typeof data) == 'string'

      if data.success
        swal
          title: 'Enroll successfully!'
          test: data.msg
          type: 'success'
      else
        if Array.isArray(data.msg)
          text = data.msg.join('\n')
        else
          text = data.msg
        swal
          title: 'Error!'
          text: text
          type: 'error'

