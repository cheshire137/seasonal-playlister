'use strict';
angular.module('seasonSoundApp').config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: '/views/lastfm_user.html',
    controller: 'PlaylistCtrl'
  }).when('/lastfm/:user', {
    templateUrl: '/views/lastfm_season.html',
    controller: 'PlaylistCtrl'
  }).otherwise({
    redirectTo: '/'
  });
}]);
