'use strict';
var redirect_user = function(cookie_store, location) {
  var user_return_to = cookie_store.get('user_return_to');
  if (user_return_to) {
    cookie_store.remove('user_return_to');
    location.path(user_return_to);
  } else {
    location.path('/');
  }
};
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
        redirect: ['$location', '$cookieStore', function ($location, $cookieStore) {
          $cookieStore.remove('rdio_user');
          redirect_user($cookieStore, $location);
        }]
      }
    }).when('/auth/failure/:strategy/:message', {
      resolve: {
        redirect: ['$location', '$route', '$cookieStore', function ($location, $route, $cookieStore) {
          var strategy_name = $route.current.params.strategy;
          strategy_name = strategy_name.charAt(0).toUpperCase() +
                          strategy_name.slice(1);
          var message = $route.current.params.message;
          $cookieStore.put('error', 'Failed to authenticate with ' +
                                    strategy_name + ': ' + message);
          redirect_user($cookieStore, $location);
        }]
      }
    }).when('/rdio/:user', {
      resolve: {
        redirect: ['$location', '$route', '$cookieStore', function ($location, $route, $cookieStore) {
          var rdio_user = $route.current.params.user;
          if (rdio_user) {
            $cookieStore.put('rdio_user', rdio_user);
          }
          redirect_user($cookieStore, $location);
        }]
      }
    // }).when('/lastfm_auth/:lastfm_token', {
    //   resolve: {
    //     redirect: ['$location', '$route', '$cookieStore', function ($location, $route, $cookieStore) {
    //       var lastfm_token = $route.current.params.lastfm_token;
    //       console.log(lastfm_token);
    //       $cookieStore.put('lastfm_token', lastfm_token);
    //       $location.path('/');
    //     }]
    //   }
    }).when('/access_token=:access_token&token_type=:token_type&expires_in=:expires_in&state=:state', {
      resolve: {
        redirect: ['$location', '$route', '$cookieStore', function ($location, $route, $cookieStore) {
          var on_bad_state = function() {
            console.error('no state came back from Spotify');
            redirect_user($cookieStore, $location);
          };
          var state = $route.current.params.state;
          if (state) {
            if (state !== $cookieStore.get('spotify_state')) {
              on_bad_state();
              return;
            }
            // All good, state matched what we originally sent
            $cookieStore.remove('spotify_state');
          } else {
            on_bad_state();
            return;
          }
          var access_token = $route.current.params.access_token;
          if (access_token) {
            $cookieStore.put('spotify_access_token', access_token);
          }
          redirect_user($cookieStore, $location);
        }]
      }
    }).when('/access_token=:access_token&token_type=:token_type&expires_in=:expires_in', {
      resolve: {
        redirect: ['$location', '$route', '$cookieStore', function ($location, $route, $cookieStore) {
          var access_token = $route.current.params.access_token;
          if (access_token) {
            $cookieStore.put('google_access_token', access_token);
          }
          redirect_user($cookieStore, $location);
        }]
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
