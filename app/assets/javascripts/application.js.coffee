#= require jquery
#= require jquery_ujs
#= require bootstrap/dist/js/bootstrap.min.js
#= require sweetalert/lib/sweet-alert.min.js
#= require slick.js/slick/slick.min.js
#= require highlightjs/highlight.pack.js
#= require ghostdown.js
#= require plupload/js/plupload.full.min.js
#= require qiniu/src/qiniu.min.js
#= require progressbar.js/dist/progressbar.min.js

#= require_self
#= require_directory ./blocks
#= require_directory .

#init hightlight.js
$ ->
    $('pre code').each (index, block)->
      if block.className.indexOf('lang-') != -1
        hljs.highlightBlock(block)

