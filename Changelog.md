# render_400

commit: 2ebbce7dabee92728c6ae9674d853f79725c173b

Use `render_400` to output error json. e.g.

```
if !user.save
  render_400 "报名失败", user.errors
  return
end
```

On the client-side, a document handler is used to pop up an alert:

```
$(document).on "ajax:error", ->
  ...
  swal(title: ..., text: ...)
```

