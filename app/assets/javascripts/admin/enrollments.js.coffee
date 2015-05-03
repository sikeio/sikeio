$ ->
  pageIdentifier = '#admin-enrollments_index '
  $(document).on "ajax:success", "#admin-enrollments_index", ->
    swal
      title: 'Send Successfully!'
      type: "success"





