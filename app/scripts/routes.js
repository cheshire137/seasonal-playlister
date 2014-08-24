'use strict';
angular.module('seasonSoundApp').config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.when('/', {
      templateUrl: '/views/lastfm_choose_user.html',
      controller: 'LastfmUserChooserCtrl',
      title: 'Choose Last.fm User'
    }).when('/lastfm/:user', {
      templateUrl: '/views/years.html',
      controller: 'YearsCtrl',
      title: 'Choose a Season'
    }).when('/lastfm/:user/:year/:season', {
      templateUrl: '/views/season.html',
      controller: 'SeasonCtrl',
      title: 'Create a Playlist'
    }).when('/logged-out/rdio', {
      resolve: {
        redirect:
          function ($location, $cookieStore) {
            $cookieStore.remove('rdio_user');
            var user_return_to = $cookieStore.get('user_return_to');
            if (user_return_to) {
              $cookieStore.remove('user_return_to');
              $location.path(user_return_to);
            } else {
              $location.path('/');
            }
          }
      }
    }).when('/rdio/:user', {
      resolve: {
        redirect:
          function ($location, $route, $cookieStore) {
            var rdio_user = $route.current.params.user;
            if (rdio_user) {
              $cookieStore.put('rdio_user', rdio_user);
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
]).run(['$route', '$rootScope', function ($route, $rootScope) {
  $rootScope.$on('$routeChangeSuccess', function () {
    if ($route.current.title) {
      $rootScope.title = $route.current.title;
    } else {
      $rootScope.title = '';
    }
  });
}]);
