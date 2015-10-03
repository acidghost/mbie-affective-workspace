app = angular.module 'mbieProjectApp'

app.controller 'HomeCtrl', [ '$scope', 'config',
  ($scope, config) ->

    $scope.$root.suggestions = []

    $scope.answerQuestion = (questionIndex, answer) ->
      question = $scope.$root.userQuestions[questionIndex]
      console.log 'User answered', question.q, 'with', question.a[answer] if config.debug.info

      distances_weights = $scope.$root.distances.map (d) -> Math.abs(d.distance) * d.weight
      sorted_dist_weights = distances_weights.slice().sort (a, b) -> b - a
      ranks_dist_weights = distances_weights.slice().map (v) -> sorted_dist_weights.indexOf v
      named_ranks = ranks_dist_weights.map (rank) -> $scope.$root.inclinationsMap[rank]

      console.log 'Ranked distances * weights', named_ranks, distances_weights if config.debug.info

      switch question.code
        when 'mood_okay'
          if not answer
            # Mood is indeed not right so
            # suggest to change some positions
            ranks_dist_weights.forEach (rank) ->
              distance = $scope.$root.distances[rank].distance
              return if Math.abs(distance) < 0.01
              component = $scope.$root.inclinationsMap[rank]
              degrees_to_change = $scope.$root.scaleToDegree(-distance).toFixed 4
              $scope.$root.suggestions.push "Try changing your #{component} position by #{degrees_to_change}"
        else
          throw new Error 'Invalid user question!'

      $scope.$root.userQuestions.splice questionIndex, 1
      $scope.$root.systemStopped = false
      $scope.$root.playing = true
      $scope.$root.posture.posture = 0

]
