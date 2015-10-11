app = angular.module 'mbieProjectApp'

app.controller 'AppCtrl', [ '$rootScope', '$state', '$localStorage', 'config',
  ($rootScope, $state, $localStorage, config) ->

    five = require 'johnny-five'
    board = new five.Board()

    gui = require 'nw.gui'
    win = gui.Window.get()
    win.showDevTools() if config.debug.info

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
    $rootScope.seatingIterations = 0
    breakStartedAt = 0
    $rootScope.maxSeatingIterations = config.maxSeatingIterations
    $rootScope.weights = $localStorage.weights or []
    $rootScope.preferred_values = $localStorage.preferred_values or []
    $rootScope.activatedSensors = [0..config.accel.length - 1]
    $rootScope.inclinationsMap = [ 'knee', 'elbow', 'back' ]
    $rootScope.inclinations = []
    $rootScope.posture =
      time: 0
      posture: 0

    board.on 'ready', ->
      console.log 'Board ready' if config.debug.info
      accelerometers = config.accel.map (conf) -> new five.Accelerometer conf

      if $rootScope.weights.length is 0
        $rootScope.weights = [1..accelerometers.length].map -> config.initialWeight
      if $rootScope.preferred_values.length is 0
        $rootScope.preferred_values = [1..accelerometers.length].map -> config.initialPreferred

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
        if breakStartedAt isnt 0
          reduceBy = Math.round(breakStartedAt / 12)
          if $rootScope.seatingIterations >= reduceBy
            $rootScope.$apply -> $rootScope.seatingIterations -= reduceBy
          else
            $rootScope.seatingIterations = 0
            breakStartedAt = 0
        return if not $rootScope.playing or $rootScope.systemStopped
        if started
          unless drawn
            drawCharts()
            drawn = true

          num_posture = 0
          weights_sum = $rootScope.weights.reduce (acc, v) -> acc + v
          $rootScope.distances = []
          $rootScope.inclinations.forEach (inclination, index) ->
            distance = inclination.scaled - $rootScope.preferred_values[index]
            # num_posture += inclination.scaled * $rootScope.weights[index]
            $rootScope.distances.push
              distance: distance
              weight: $rootScope.weights[index]
            num_posture += Math.abs(distance) * $rootScope.weights[index]

          thisPosture = num_posture / weights_sum
          if thisPosture < config.postureDecrement
            thisPosture = 0
            unless $rootScope.posture.posture < config.postureDecrement
              thisPosture = -config.postureDecrement

          posture =
            time: Date.now()
            posture: $rootScope.posture.posture + thisPosture
          $rootScope.posture = posture
          insertPostureInChart posture
          console.log 'Posture', posture if config.debug.sensors

          $rootScope.seatingIterations++

          if posture.posture > config.postureThreshold
            console.log 'Posture th. reached' if config.debug.info
            $rootScope.$apply ->
              $rootScope.systemStopped = true
              $rootScope.playing = false
              $rootScope.suggestions = []
              $rootScope.moodQuestion =
                q: 'Is your mood okay right now?'
                a: [ 'No', 'Yes' ]
              $state.go 'home'

      window.setInterval mainLoop, config.loopFreq

    $rootScope.exitApp = ->
      $localStorage.preferred_values = $rootScope.preferred_values
      $localStorage.weights = $rootScope.weights

      # Allow saving...
      window.setTimeout gui.App.quit, 100

    $rootScope.takeBreak = ->
      $rootScope.playing = false
      breakStartedAt = $rootScope.seatingIterations

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
        duration: Math.round(config.loopFreq / 2)
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
          y:
            max: config.postureThreshold
            min: 0
]
