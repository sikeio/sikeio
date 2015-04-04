$ ->
  eventPrefix = '.admin-enrollments-page'
  $ = jQuery.getLocal(eventPrefix)

  $(document)
    .on 'ajax:success','.email-panel form',->
      $('.email-panel').hide().find('textarea').val('')
      swal
        title: 'Send Successfully!'
        type: "success"


    .on 'click','.enrollments .send',->
      enrollmentId = $(this).attr('data-enrollment-id')
      $('.email-panel').find('[name=id]').val enrollmentId
      $('.email-panel').show()

    .on 'click','.email-panel .cancel',->
      $('.email-panel').hide()





