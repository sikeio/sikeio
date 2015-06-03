$ ->
  uploader = Qiniu.uploader
    runtimes: 'html5,flash,html4',
    browse_button: 'pickfiles',
    container: 'upload-area',
    drop_element: 'upload-area',
    max_file_size: '4mb',
    flash_swf_url: '/plupload/Moxie.swf',
    dragdrop: true,
    chunk_size: '4mb',
    uptoken_url: "/qiniu/uptoken"
    domain: "http://7xjfes.com1.z0.glb.clouddn.com/",
    unique_names: true,
    auto_start: true,
    init:
      'BeforeUpload': (up, file)->
        $("<div class='progress #{file.id}'>").appendTo('.markdown-editor__progress')
        line = new ProgressBar.Line(".#{file.id}", {color: '#33B2E3'})
        $(".#{file.id}").data 'progress', line

      'UploadProgress': (up, file)->
        line = $(".#{file.id}").data 'progress'
        line.animate(file.percent / 100)

      'FileUploaded': (up, file, info)->
        domain = up.getOption('domain')
        res = JSON.parse(info)
        FileURL = domain + res.key;

        $("<input type='hidden' name='checkin[uploaded_images][]' value=#{res.key}>").appendTo('form.js-checkin .uploaded-images')

        markdownImg = "![](#{FileURL})"
        doc = $('#entry-markdown').data('editor').getDoc()

        doc.setValue doc.getValue() + "\n\n#{markdownImg}"

        window.setTimeout ->
          $(".#{file.id}").fadeOut()
        , 2000


      'Error': (up, err, errTip)->
        swal
          type: 'error'
          title: "文件上传出错误！"
          text: err

  pageIdentifier = "#checkins_show "
  $(document)
    .on "ajax:success", pageIdentifier + ".js-checkin", (e, data) ->
      if data.success
        window.location.replace(data.url)
      else
        swal
          title: "有点小问题~"
          text: data.message
          type: "error"
