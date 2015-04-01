$ ->
  eventPrefix = ".enrollments-page.invite"
  $ = jQuery.getLocal(eventPrefix)


$ ->
  eventPrefix = ".enrollments-page.pay"
  $ = jQuery.getLocal(eventPrefix)
  $(document)
    .on 'click','.start-course',->
      $('form').submit()




