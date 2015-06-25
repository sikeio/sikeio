###
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
###

# video modal effect
$ ->
  $('body').on 'hide.bs.modal', '#videoModal', (e) =>
    $('#videoModal').remove()
    $('video').trigger('pause')

  $('video').click (e) ->
    # generate modal element and added after video link
    src = $(this).attr('src');
    id = src.substring(src.lastIndexOf('/') + 1, src.lastIndexOf('.'));
    console.log("id:" + id);
    modalStr = "
      <div class='video-modal modal fade' id='videoModal' tabindex='-1' role='dialog'>
        <div class='modal-dialog' role='document'>
          <div class='modal-content'>
            <div class='modal-body'>
              <video id='modal-video-#{id}' src='#{src}' width='100%!important' height='100%' controls></video>
            </div>
          </div>
        </div>
      </div>"
    $(this).after(modalStr)

    # pop up the video modal
    $('#videoModal').modal({})
    # start to play
    $("#modal-video-"+id).trigger('play')



