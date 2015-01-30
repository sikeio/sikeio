#<div class='enroll-panel'>
html = """
  <div class="top">
    Image
  </div>
  <form>
    <input>
    <input>
    <button>Enrol</button>
  </form>
"""
#</div>

panel = null

createPanel = ->
  element = document.createElement('div')
  element.className = 'enroll-panel'
  element.innerHTML = html
  return element

showPanel = ->
  panel.style.display = ""

hidePanel = ->
  panel.style.display = 'none'

document.querySelector('#enroll').addEventListener 'click',(e)->
  data =
    has_logged_in:false
    has_enrolled: false

  if data.has_logged_in
    if data.has_enrolled
      window.location = "course index page"
    else
      window.location = "course payment page"
  else
    panel ||= createPanel()
    document.body.appendChild panel
    showPanel()

    e.preventDefault()
    e.stopPropagation()

document.body.addEventListener 'click',->
  hidePanel()




