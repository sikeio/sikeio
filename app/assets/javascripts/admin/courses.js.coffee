$ ->
  $('.js-generate-discourse-topics').on 'ajax:success', ->
    swal
      title: 'Successful!!'
      type: 'success'