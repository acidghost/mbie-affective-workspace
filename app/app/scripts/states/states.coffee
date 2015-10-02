app = angular.module 'mbieProjectApp'

app.config [ '$urlRouterProvider', '$stateProvider', 'viewProvider',
  ($urlRouterProvider, $stateProvider, viewProvider) ->

    $urlRouterProvider.otherwise '/'

    $stateProvider
      .state 'home',
        url: '/'
        template: viewProvider.renderView 'home'
        controller: 'HomeCtrl'
      .state 'data',
        url: '/data'
        template: viewProvider.renderView 'data'

]
