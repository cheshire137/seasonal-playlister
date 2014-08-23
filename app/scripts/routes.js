'use strict';
angular.module('seasonSoundApp').config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.when('/', {
      templateUrl: '/views/lastfm_choose_user.html',
      controller: 'LastfmUserChooserCtrl'
    }).when('/lastfm/:user', {
      templateUrl: '/views/years.html',
      controller: 'YearsCtrl'
    }).when('/lastfm/:user/:year/:season', {
      templateUrl: '/views/season.html',
      controller: 'SeasonCtrl'
    }).when('/lastfm/:user/:year/:season/artist/:artist/play-count/:min_play_count/google-playlist', {
      templateUrl: '/views/google_playlist.html',
      controller: 'SeasonCtrl'
    }).when('/access_token=:access_token&token_type=:token_type&expires_in=:expires_in', {
      resolve: {
        redirect:
          function ($location, $route, $cookieStore) {
            var access_token = $route.current.params.access_token;
            if (access_token) {
              $cookieStore.put('access_token', access_token);
            }
            var user_return_to = $cookieStore.get('user_return_to');
            if (user_return_to) {
              $cookieStore.remove('user_return_to');
              $location.path(user_return_to);
            } else {
              $location.path('/');
            }
          }
      }
    }).otherwise({
      redirectTo: '/'
    });
  }
]);
