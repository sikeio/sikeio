$ ->
  eventPrefix = '.admin-users-page'
  $ = jQuery.getLocal(eventPrefix)

  $(document)
    .on 'ajax:success','.email-panel form',->
      $('.email-panel').hide().find('textarea').val('')
      swal
        title: 'Send Successfully!'
        type: "success"


    .on 'click','.users .activate',->
      userId = $(this).attr('data-user-id')
      $('.email-panel').find('[name=user_id]').val userId
      $('.email-panel').show()

    .on 'click','.email-panel .cancel',->
      $('.email-panel').hide()





