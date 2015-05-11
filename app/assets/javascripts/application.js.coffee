#= require jquery
#= require jquery_ujs
#= require bootstrap/dist/js/bootstrap.min.js
#= require sweetalert/lib/sweet-alert.min.js
#= require slick.js/slick/slick.min.js
#= require highlightjs/highlight.pack.js
#= require ghostdown.js

#= require_self
#= require_directory ./blocks
#= require_directory .

#init hightlight.js
$ ->
    $('pre code').each (index, block)->
      if block.className.indexOf('lang-') != -1
        hljs.highlightBlock(block)

