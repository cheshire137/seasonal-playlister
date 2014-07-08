seasonal_app.controller 'LastfmUserController', ($scope, $location, LastfmChartsSvc) ->
  $scope.lastfm_user = LastfmChartsSvc.user

  $scope.go_to_weeks_list = ->
    $location.path("/lastfm/#{$scope.lastfm_user.user_name}")
