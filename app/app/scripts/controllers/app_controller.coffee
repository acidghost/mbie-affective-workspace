app = angular.module 'mbieProjectApp'

app.controller 'AppCtrl', [ '$rootScope', '$state', '$localStorage', 'config',
  ($rootScope, $state, $localStorage, config) ->

    five = require 'johnny-five'
    board = new five.Board()

    scaleAngle = (angle) ->
      (angle - -180) / (180 - -180)

    board.on 'ready', ->
      console.log 'Board ready' if config.debug
      $rootScope.weight = 1
      accel = new five.Accelerometer config.accel

      time = Date.now()
      accel.on 'acceleration', ->
        if Date.now() - time > config.freq
          time = Date.now()
          inclination =
            degree: this.inclination
            scaled: scaleAngle this.inclination

          console.log time, 'Inclination', inclination if config.debug
          $rootScope.$apply -> $rootScope.inclination = inclination

]
