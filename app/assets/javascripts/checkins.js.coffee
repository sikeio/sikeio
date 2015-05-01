$ ->
  pageIdentifier = "#checkins_show "
  $(document)
    .on "ajax:success", pageIdentifier + ".js-checkin", (e, data) ->
      if data.success
        window.location.replace(data.url)
      else
        swal
          title: "错误~"
          text: data.message
          type: "error"
