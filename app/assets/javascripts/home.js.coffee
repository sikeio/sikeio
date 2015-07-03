$ ->
  pageIdentifier = '#home_index '
  $(document)
    .on 'ajax:success', pageIdentifier + '.subscribe', (e,data)->
      swal
        title: "订阅成功~"

$ ->
  pageIdentifier = "#home_index  "
  $(document)
    .on 'ajax:success', pageIdentifier + '.js-panel--enrolling__form', ->
      $(".js-modal").trigger("show","div.js-panel--success")

