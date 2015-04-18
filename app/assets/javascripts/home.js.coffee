$ ->
  pageIdentifier = '#home_index '
  $(document)
    .on 'ajax:success', pageIdentifier + '.subscribe', (e,data)->
      swal
        title: "订阅成功~"
