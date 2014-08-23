'use strict';

angular.module('seasonSoundApp')
  .controller('NotificationsCtrl', function ($scope, NotificationSvc) {
    $scope.notices = NotificationSvc.notices;
    $scope.errors = NotificationSvc.errors;

    $scope.remove = function (notification_type, notification_id) {
      NotificationSvc.remove(notification_type, notification_id);
    };
  });
