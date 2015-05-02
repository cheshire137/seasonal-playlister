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
  ]
