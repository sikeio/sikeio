$ ->
  eventPrefix = '#admin-enrollments_index'
  $ = jQuery.getLocal(eventPrefix)

  $(document)
    .on 'ajax:success', '.email-panel form', ->
      $('.email-panel').hide().find('textarea').val('')
      swal
        title: 'Send Successfully!'
        type: "success"

    .on 'click', '.enrollments .send-invitation-email', ->
      url = $(this).attr 'href'
      $('.email-panel form').attr 'action', url
      $('.email-panel').show()
      $('.email-panel textarea').focus()
      return false

    .on 'click', '.email-panel .cancel', ->
      $('.email-panel').hide()

    .on 'ajax:success', '.enrollments .pay', ->
      swal
        title: 'Set Successfully!'
        type: "success"
      $('td.paid').text 'true'

    .on 'ajax:success', '.enrollments .send-welcome-email', ->
      swal
        title: 'Send Successfully'
        type: 'success'






