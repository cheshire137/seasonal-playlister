'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:NotificationsCtrl
 # @description
 # # NotificationsCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'NotificationsCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
