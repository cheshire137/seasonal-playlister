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
  }).when('/lastfm/:user/:year/:season/artist/:artist/play-count/:min_play_count/google-playlist', {
    templateUrl: '/views/google_playlist.html',
    controller: 'GoogleMusicCtrl'
  }).when('/oauth2callback', {
    templateUrl: '/views/google_signed_in.html',
    controller: 'GoogleMusicCtrl'
  }).otherwise({
    redirectTo: '/'
  });
}]);
