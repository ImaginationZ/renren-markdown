###!
process
!###

process = {}

process.sync = ->
  md = ui.getSource()
  el = markdown.convert md
  process._async = postproc.run el
  ui.setPreview el
  ui.setPreviewCss markdown.cssText

# ensure that each `async` from `postproc.run` is run only once
process._async = (->)
process.async = (cb) ->
  el = ui.getPreview()
  core.inlineCss(el, markdown.cssRules)
  process._async(cb)
  process._async = (->)

process.open = ->
  tinymce.call 'getContent', (err, ret) ->
    md = core.unembed ret
    ui.setSource md
    cron.trig()
    ui.show()

process.commit = ->
  md = ui.getSource()
  el = ui.getPreview()
  core.relayAllImg el
  core.spanify el
  embed = core.embed md
  # TODO: extra steps
  tinymce.call 'setContent', el.innerHTML + embed, (->)
  ui.hide()
