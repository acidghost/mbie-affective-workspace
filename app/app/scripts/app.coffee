app = angular.module 'mbieProjectApp', [
  'ui.router',
  'ui.bootstrap',
  'ngStorage'
]

app.constant 'config', require("../config/#{process.env.MBIE_ENV or 'dev'}")

app.run ->
  Readable = require('stream').Readable
  util = require('util')

  MyStream = (opt) ->
    Readable.call this, opt

  util.inherits MyStream, Readable

  MyStream::_read = ->

  # hook in our stream
  process.__defineGetter__ 'stdin', ->
    if process.__stdin
      return process.__stdin
    process.__stdin = new MyStream
    process.__stdin
