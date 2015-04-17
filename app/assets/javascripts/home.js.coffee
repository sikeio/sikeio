$ ->
  $(document)
    .on '#home_index ajax:success','.subscribe',(e,data)->
      swal
        title: "订阅成功~"
