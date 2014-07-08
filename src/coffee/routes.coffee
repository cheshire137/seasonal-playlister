seasonal_app.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/',
    templateUrl: '/lastfm_user.html'
    controller: seasonal_app.PlaylistController

  $routeProvider.when '/lastfm/:user',
    templateUrl: '/lastfm_season.html'
    controller: seasonal_app.PlaylistController

  $routeProvider.otherwise
    redirectTo: '/'
])
