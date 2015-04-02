$ ->
  page_identifier = 'courses-page'
  $ = jQuery.getLocal(page_identifier)

  $('i.fa.fa-check-circle').click (e)->
   $('#checkout_modal').modal({
          backdrop: false
       })

  $('button.close').click (e)->
   $('#checkout_modal').modal('hide')

  $('i.fa.fa-check-circle').mouseenter (e)->
    $(this).css("color", "#11D146")
    $(this).css("cursor", "pointer")

  $('i.fa.fa-check-circle').mouseleave (e)->
    $(this).css("color", "" )
    $(this).css("cursor", "")

