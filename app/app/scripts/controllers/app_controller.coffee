app = angular.module 'mbieProjectApp'

app.controller 'AppCtrl', [ '$rootScope', '$state', '$localStorage', 'config',
  ($rootScope, $state, $localStorage, config) ->

    five = require 'johnny-five'
    board = new five.Board()

    gui = require 'nw.gui'

    scaleAngle = (angle) ->
      (angle - -180) / (180 - -180)

    $rootScope.scaleToDegree = (distance) ->
      new_range = 360
      old_range = 1
      ((distance * new_range) / old_range)

    started = false
    drawn = false
    $rootScope.playing = true
    $rootScope.systemStopped = false
    timeAxis = [ Date.now() ]
    postureAxis = [ 0.0 ]

    timers = []
    weights = $localStorage.weights or []
    preferred_values = $localStorage.preferred_values or []
    $rootScope.inclinationsMap = [ 'knee', 'elbow', 'back' ]
    $rootScope.inclinations = []
    $rootScope.posture =
      time: 0
      posture: 0

    board.on 'ready', ->
      console.log 'Board ready' if config.debug.info
      accelerometers = config.accel.map (conf) -> new five.Accelerometer conf

      if weights.length is 0
        weights = [1..accelerometers.length].map -> 1
      if preferred_values.length is 0
        preferred_values = [1..accelerometers.length].map -> .53

      [1..accelerometers.length].forEach ->
        timers.push Date.now()
        $rootScope.inclinations.push null

      accelerometers.forEach (accelerometer, index) ->
        accelerometer.on 'data', ->
          return if not $rootScope.playing or $rootScope.systemStopped
          started = true unless started
          if Date.now() - timers[index] > config.freq
            timers[index] = Date.now()
            inclination =
              time: timers[index]
              degree: this.inclination
              scaled: scaleAngle this.inclination

            console.log 'Inclination', index, '\t', inclination if config.debug.sensors
            $rootScope.$apply -> $rootScope.inclinations[index] = inclination

      mainLoop = ->
        return if not $rootScope.playing or $rootScope.systemStopped
        if started
          unless drawn
            drawCharts()
            drawn = true
          num_posture = 0
          weights_sum = weights.reduce (acc, v) -> acc + v
          $rootScope.distances = []
          $rootScope.inclinations.forEach (inclination, index) ->
            distance = inclination.scaled - preferred_values[index]
            # num_posture += inclination.scaled * weights[index]
            $rootScope.distances.push
              distance: distance
              weight: weights[index]
            num_posture += distance * weights[index]

          posture =
            time: Date.now()
            posture: $rootScope.posture.posture + num_posture / weights_sum
          $rootScope.posture = posture
          insertPostureInChart posture
          console.log 'Posture', posture if config.debug.sensors

          if Math.abs(posture.posture) > config.postureThreshold
            console.log 'Posture th. reached' if config.debug.info
            $rootScope.$apply ->
              $rootScope.systemStopped = true
              $rootScope.playing = false
              $rootScope.suggestions = []
              $rootScope.userQuestions = [
                code: 'mood_okay'
                q: 'Is your mood okay right now?'
                a: [ 'No', 'Yes' ]
              ]
              $state.go 'home'

      window.setInterval mainLoop, config.loopFreq

    $rootScope.exitApp = ->
      $localStorage.preferred_values = $rootScope.preferred_values
      $localStorage.weights = weights

      gui.App.quit()

    insertPostureInChart = (posture) ->
      return unless $rootScope.postureChart
      timeAxis.push posture.time
      postureAxis.push posture.posture
      if timeAxis.length > config.chartsWindow
        timeAxis.shift()
        postureAxis.shift()

      xAxis = timeAxis.slice()
      yAxis = postureAxis.slice()
      xAxis.unshift('x')
      yAxis.unshift('posture')
      $rootScope.postureChart.flow
        columns: [ xAxis, yAxis ]
        duration: 500
        # length: config.chartsWindow
        to: xAxis[1]

    drawCharts = ->
      xAxis = timeAxis.slice()
      yAxis = postureAxis.slice()
      xAxis.unshift('x')
      yAxis.unshift('posture')
      $rootScope.postureChart = c3.generate
        bindto: '#posture-chart'
        data:
          type: 'bar'
          x: 'x'
          columns: [ xAxis, yAxis ]
        axis:
          x:
            type: 'timeseries'
            tick:
              format: '%H:%M:%S'
]
