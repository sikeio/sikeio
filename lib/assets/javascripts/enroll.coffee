#outer div.enroll-panel
enroll_html = """
  <div class="top">
    <img src="/assets/enroll_author.png" alt="">
    <div class="say">
      <p class="top">嗨~我是 Howard 很高兴认识你。我希望先了解你的技术背景和学习动机，再决定这个训练营是否能对你有帮助。</p>
      <p>请在下面留下你的邮箱，我会在 2 天内和你联系。</p>
    </div>
  </div>
  <form method='post' action="/courses/enroll" id="enroll-form">
    <label>姓名</label>
    <input class="name" type="text" name='name'>
    <br>
    <label>邮箱</label>
    <input class='email' type="text" name='email'>
    <br>
    <button type="submit">申请加入</button>
  </form>
"""

#outer div.success-panel
success_html = """
  <img class="author" src="/assets/enroll_author.png" alt="">
  <div class="say">
    <p class="top">邮件已发出，期待和你交流！我的个人微信账号是 hayeah666，有问题可以加我~</p>
  </div>
  <img src="/assets/weixin.png" alt="">
  <p>微信：hayeah666</p>
"""

panel = null


createPanel = ->
  element = document.createElement('div')
  element.className = 'enroll-panel'
  element.innerHTML = enroll_html
  return element

showPanel = (target = panel)->
  target.style.display = ""

hidePanel = (target = panel)->
  target.style.display = 'none'


document.querySelector('#enroll').addEventListener 'click',(e)->

  xml = new XMLHttpRequest()
  xml.onreadystatechange = ->
    if xml.status == 200 && xml.readyState == 4
      data = JSON.parse xml.responseText
      if data.has_logged_in
        if data.has_enrolled
          window.location = "course index page"
        else
          window.location = "course payment page"
      else
        panel ||= createPanel()
        bindEvent()
        document.body.appendChild panel
        showPanel()

        e.preventDefault()
        e.stopPropagation()

  course_id = document.body.getAttribute("data-course-id")
  throw new Error() unless course_id
  url = "/courses/get_user_status?course_id=#{course_id}"
  xml.open("GET",url)
  xml.send()

bindEvent = ->
  panel.addEventListener 'submit',(e)->
    name = document.querySelector('form input.name').value
    email = document.querySelector('form input.email').value
    if name == "" || email == ""
      swal
        title: "名称和电子邮件不能为空~"
        type: 'error'
    else
      xml = new XMLHttpRequest()
      xml.onreadystatechange = ->
        if xml.readyState == 4 && xml.status == 200
          result = JSON.parse(xml.responseText)
          if result.success
            success = document.createElement('div')
            success.className = 'success-panel'
            success.innerHTML = success_html
            document.body.appendChild success
            showPanel success
            hidePanel()
          else
            swal
              title: "Enroll失败~"
              text: result.msg.join("\n")
              type: "error"

      xml.open "POST","/courses/enroll"
      xml.setRequestHeader "Content-Type","application/x-www-form-urlencoded"
      xml.send("name=#{name}&email=#{email}")

    e.preventDefault()
    e.stopPropagation()


document.body.addEventListener 'click',(e)->
  x = e.offsetX
  y = e.offsetY
  return false unless panel
  hidePanel() if x < 0 ||  x > panel.offsetWidth || y < 0 || y > panel.offsetHeight