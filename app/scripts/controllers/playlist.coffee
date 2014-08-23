'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:PlaylistCtrl
 # @description
 # # PlaylistCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'PlaylistCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
