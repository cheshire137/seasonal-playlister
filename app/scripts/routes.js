'use strict';
angular.module('seasonSoundApp').config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: '/views/lastfm_choose_user.html',
    controller: 'LastfmUserChooserCtrl'
  }).when('/lastfm/:user', {
    templateUrl: '/views/years.html',
    controller: 'YearsCtrl'
  }).when('/lastfm/:user/:year/:season', {
    templateUrl: '/views/season.html',
    controller: 'SeasonCtrl'
  }).otherwise({
    redirectTo: '/'
  });
}]);
