app = angular.module 'mbieProjectApp'

app.provider 'view', ->

  jade = require('jade')
  fs = require('fs')
  path = require('path')

  templates = {}

  files = fs.readdirSync path.resolve('./templates')
  console.log "Found #{files.length} files"
  _.each files, (f) ->
    templates[f.substring(0, f.length - 5)] =
      tmplfile: fs.readFileSync(path.resolve('./templates', f))
      tmplpath: path.resolve('./templates', f)
      compiled: false

  class ViewRenderer

    @renderView = (name, context, options) ->
      (params, path) ->
        tmpl = templates[name]
        if !tmpl.compiled
          console.log "View #{name} isn't compiled, compiling it now"
          tmpl.tmpl = jade.compile(tmpl.tmplfile, 'filename': tmpl.tmplpath)
          tmpl.compiled = true
        tmpl.tmpl _.extend(context or {},
          params: params
          path: path)

    @$get = ->
      new ViewRenderer
