$ ->
  pageIdentifier = '#admin-enrollments_index '
  $(document)
    .on 'ajax:success', pageIdentifier + '.email-panel form', ->
      $('.email-panel').hide().find('textarea').val('')
      swal
        title: 'Send Successfully!'
        type: "success"

    .on 'ajax:success', pageIdentifier + '.enrollments .pay', ->
      swal
        title: 'Set Successfully!'
        type: "success"
      $('td.paid').text 'true'

    .on 'ajax:success', pageIdentifier + '.enrollments .send-welcome-email', ->
      swal
        title: 'Send Successfully'
        type: 'success'






