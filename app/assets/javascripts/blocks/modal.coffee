$ ->
  # Trigger modal in code by sending an event to `.js-modal`
  #
  # To show:
  #    $('.js-modal').trigger("show",$target)
  # To hide:
  #    $('.js-modal').trigger("hide")
  #
  # To embed a modal trigger in html:
  #
  # <button class="js-modal-trigger" data-modal-target="#target">

  $modal = $("<div class='js-modal'>").appendTo('body')
  $overlay = $('<div class="js-modal__overlay">').appendTo($modal)
  $overlay.css {
    display: "none"
    position: "fixed"
    top: 0
    bottom: 0
    left: 0
    right: 0
    background: "rgba(0,0,0,0.6)"
  }

  $currentTarget = null

  $overlay.on "click", (e) ->
    $modal.trigger("hide")
    e.stopPropagation()

  $modal.on "show", (e,target) ->
    if $currentTarget != null
      $currentTarget.hide()
    $currentTarget = $(target)
    $overlay.show()
    $currentTarget.show()

  $modal.on "hide", (e) ->
    $overlay.hide()
    $currentTarget.hide()
    $currentTarget = null


  $(".js-modal-trigger").on "click", ->
    target = $(this).data("modal-target")
    $modal.trigger("show",target)