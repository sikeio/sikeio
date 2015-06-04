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
