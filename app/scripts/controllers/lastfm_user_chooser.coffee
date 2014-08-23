'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:LastfmUserChooserCtrl
 # @description
 # # LastfmUserChooserCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'LastfmUserChooserCtrl', ($scope) ->
    $scope.go_to_seasons_list = ->
