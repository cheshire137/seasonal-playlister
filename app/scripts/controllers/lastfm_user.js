'use strict';

angular.module('seasonSoundApp')
  .controller('LastfmUserCtrl', function ($scope, $location, LastfmChartsSvc) {
    $scope.lastfm_user = LastfmChartsSvc.user;

    $scope.go_to_weeks_list = function() {
      $location.path('/lastfm/' + $scope.lastfm_user.user_name);
    };
  });
