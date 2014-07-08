seasonal_app.controller 'NotificationsController', ($scope, NotificationSvc) ->
  $scope.notices = NotificationSvc.notices
  $scope.errors = NotificationSvc.errors

  $scope.remove = (notification_type, notification_id) ->
    NotificationSvc.remove notification_type, notification_id
