$ ->
  eventPrefix = '.admin-enrollments-page.index'
  $ = jQuery.getLocal(eventPrefix)

  $(document)
    .on 'ajax:success', '.email-panel form', ->
      $('.email-panel').hide().find('textarea').val('')
      swal
        title: 'Send Successfully!'
        type: "success"

    .on 'click', '.enrollments .send', ->
      url = $(this).attr 'href'
      $('.email-panel form').attr 'action', url
      $('.email-panel').show()
      return false

    .on 'click', '.email-panel .cancel', ->
      $('.email-panel').hide()

    .on 'ajax:success', '.enrollments .pay', ->
      swal
        title: 'Set Successfully!'
        type: "success"
      $('td.paid').text 'true'





