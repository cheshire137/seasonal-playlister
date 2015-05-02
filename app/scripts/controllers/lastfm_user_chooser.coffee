'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:LastfmUserChooserCtrl
 # @description
 # # LastfmUserChooserCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'LastfmUserChooserCtrl',
  ['$scope', '$location', 'LastfmChartsSvc',
  ($scope, $location, LastfmChartsSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user

    $scope.go_to_seasons_list = ->
      $location.path("/lastfm/#{$scope.lastfm_user.user_name}")

    $scope.init_lastfm_auth = ->
      api_key = window.seasonSoundConfig.lastfm_api_key
      window.location.href = 'http://www.last.fm/api/auth/' +
                             '?api_key=' + api_key +
                             '&cb=' + window.location.origin + '/lastfm_auth'
  ]
