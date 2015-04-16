$ ->
  pageIdentifier = '#admin-enrollments_index '
  $(document)
    .on 'ajax:success', pageIdentifier + '.email-panel form', ->
      $('.email-panel').hide().find('textarea').val('')
      swal
        title: 'Send Successfully!'
        type: "success"

    .on 'click', pageIdentifier + '.enrollments .send-invitation-email', ->
      url = $(this).attr 'href'
      $('.email-panel form').attr 'action', url
      $('.email-panel').show()
      $('.email-panel textarea').focus()
      return false

    .on 'click', pageIdentifier + '.email-panel .cancel', ->
      $('.email-panel').hide()

    .on 'ajax:success', pageIdentifier + '.enrollments .pay', ->
      swal
        title: 'Set Successfully!'
        type: "success"
      $('td.paid').text 'true'

    .on 'ajax:success', pageIdentifier + '.enrollments .send-welcome-email', ->
      swal
        title: 'Send Successfully'
        type: 'success'






