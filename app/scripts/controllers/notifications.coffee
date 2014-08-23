'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:NotificationsCtrl
 # @description
 # # NotificationsCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'NotificationsCtrl', ($scope, NotificationSvc) ->
    $scope.notices = NotificationSvc.notices
    $scope.errors = NotificationSvc.errors

    $scope.remove = (notification_type, notification_id) ->
      NotificationSvc.remove notification_type, notification_id
