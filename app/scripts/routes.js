'use strict';
angular.module('seasonSoundApp').config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: '/views/lastfm_choose_user.html',
    controller: 'LastfmUserChooserCtrl'
  }).when('/lastfm/:user', {
    templateUrl: '/views/years.html',
    controller: 'YearsCtrl'
  }).when('/lastfm/:user/:year/spring', {
    templateUrl: '/views/spring.html',
    controller: 'SpringCtrl'
  }).when('/lastfm/:user/:year/summer', {
    templateUrl: '/views/summer.html',
    controller: 'SummerCtrl'
  }).when('/lastfm/:user/:year/fall', {
    templateUrl: '/views/fall.html',
    controller: 'FallCtrl'
  }).when('/lastfm/:user/:year/winter', {
    templateUrl: '/views/winter.html',
    controller: 'WinterCtrl'
  }).otherwise({
    redirectTo: '/'
  });
}]);
