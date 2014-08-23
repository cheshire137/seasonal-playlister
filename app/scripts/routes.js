'use strict';
angular.module('seasonSoundApp').config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: '/views/lastfm_user.html',
    controller: 'LastfmUserChooserCtrl'
  }).when('/lastfm/:user', {
    templateUrl: '/views/lastfm_season.html',
    controller: 'LastfmUserChooserCtrl'
  }).otherwise({
    redirectTo: '/'
  });
}]);
