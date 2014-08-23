'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:LastfmUserCtrl
 # @description
 # # LastfmUserCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'LastfmUserCtrl', ($scope, $location, LastfmChartsSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user

    $scope.go_to_weeks_list = ->
      $location.path("/lastfm/#{$scope.lastfm_user.user_name}")
