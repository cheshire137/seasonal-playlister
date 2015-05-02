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
  ['$scope', '$location', '$cookieStore', 'LastfmChartsSvc',
  ($scope, $location, $cookieStore, LastfmChartsSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user
    $scope.lastfm_auth =
      is_authenticated: $cookieStore.get('lastfm_is_authenticated')
      user_name: $cookieStore.get('lastfm_authenticated_user')

    $scope.go_to_seasons_list = ->
      $location.path("/lastfm/#{$scope.lastfm_user.user_name}")

    $scope.get_authenticated_scrobbles = ->
      $location.path("/lastfm/#{$scope.lastfm_auth.user_name}")

    $scope.init_lastfm_auth = ->
      api_key = window.seasonSoundConfig.lastfm_api_key
      window.location.href = 'http://www.last.fm/api/auth/' +
                             '?api_key=' + api_key +
                             '&cb=' + window.location.origin + '/lastfm_auth'
  ]
