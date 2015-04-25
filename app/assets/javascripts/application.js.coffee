#= require jquery
#= require jquery_ujs
#= require bootstrap/dist/js/bootstrap.min.js
#= require sweetalert/lib/sweet-alert.min.js
#= require turbolinks
#= require slick.js/slick/slick.min.js
#= require highlightjs/highlight.pack.js

#= require_self
#= require_directory ./blocks
#= require_directory .

# default ajax error handling
$(document).on "ajax:error", (evt,xhr,error) ->
  if xhr.status >= 500
    swal
      title: "Server error"
      text: "Server error text"
    return

  data = xhr.responseJSON
  title = error
  if data["msg"]
    title = data["msg"]

  # Combine ActiveModel errors
  text = ""
  if errors = data["errors"]
    chunks = []
    for field, detail of errors
      if detail instanceof Array
        for msg in detail
          chunks.push("#{field} #{msg}")
      else
        chunks.push("#{field} #{detail}")
    text = chunks.join("\n")


  swal
    title: title
    text: text
    type: 'error'

#init hightlight.js
hljs.initHighlightingOnLoad();
