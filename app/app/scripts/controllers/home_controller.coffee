app = angular.module 'mbieProjectApp'

app.controller 'HomeCtrl', [ '$scope', '$state', 'config',
  ($scope, $state, config) ->

    $scope.$root.suggestions = []

    $scope.answerMoodQuestion = (answer) ->
      question = $scope.$root.moodQuestion
      console.log 'User answered', question.q, 'with', question.a[answer] if config.debug.info
      $scope.$root.moodQuestion = undefined

      distances_weights = $scope.$root.distances.map (d) -> Math.abs(d.distance) * d.weight
      sorted_dist_weights = distances_weights.slice().sort (a, b) -> b - a
      ranks_dist_weights = distances_weights.slice().map (v) -> sorted_dist_weights.indexOf v
      named_ranks = ranks_dist_weights.map (rank) -> $scope.$root.inclinationsMap[rank]

      console.log 'Ranked distances * weights', named_ranks, distances_weights if config.debug.info

      if not answer
        # Mood is indeed not right so
        # suggest to change some positions
        ranks_dist_weights.forEach (rank) ->
          distance = $scope.$root.distances[rank].distance
          return if Math.abs(distance) < config.supportThreshold
          component = $scope.$root.inclinationsMap[rank]
          degrees_to_change = $scope.$root.scaleToDegree(distance).toFixed 4
          $scope.$root.suggestions.push "Try changing your #{component} position by #{degrees_to_change}"

        canContinue 'home'
      else
        # Mood is instead right so
        # update preferred_values...
        $scope.$root.preferred_values = $scope.$root.preferred_values.map (pref_value, index) ->
          distance = $scope.$root.distances[index].distance
          pref_value + distance
        console.log 'Preferred values updated', $scope.$root.preferred_values if config.debug.info

        # ... and update weights
        # asking which components cause more stress
        $scope.selectedComponents = $scope.$root.activatedSensors.map -> false
        $scope.$root.componentsQuestion =
          q: 'Which of the following is causing you more stress?'
          a: $scope.$root.activatedSensors.map (as) -> $scope.$root.inclinationsMap[as]
          answer: ->
            console.log 'Components that cause more stress', $scope.selectedComponents if config.debug.info
            $scope.selectedComponents.forEach (cause_stress, index) ->
              $scope.$root.weights[index] += config.weightIncrement if cause_stress

            canContinue 'data'

    canContinue = (where) ->
      $scope.$root.componentsQuestion = undefined
      $scope.$root.systemStopped = false
      $scope.$root.playing = true
      $scope.$root.posture.posture = 0

      $state.go where

]
