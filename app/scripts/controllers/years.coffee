'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:YearsCtrl
 # @description
 # # YearsCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'YearsCtrl', ['$scope', '$routeParams', '$cookieStore', 'NotificationSvc', 'LastfmChartsSvc', ($scope, $routeParams, $cookieStore, NotificationSvc, LastfmChartsSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user
    $scope.load_status = LastfmChartsSvc.load_status
    $scope.year_charts = LastfmChartsSvc.year_charts
    $scope.lastfm_neighbors = LastfmChartsSvc.neighbors
    $scope.chart_filters = {}

    $scope.wipe_notifications = ->
      NotificationSvc.wipe_notifications()

    unless $routeParams.user == $cookieStore.get('lastfm_user')
      LastfmChartsSvc.reset_user()
      $cookieStore.put('lastfm_user', $routeParams.user)
      LastfmChartsSvc.reset_charts()

    $scope.lastfm_user.user_name = $cookieStore.get('lastfm_user')

    unless $scope.load_status.charts
      user_name = $scope.lastfm_user.user_name
      LastfmChartsSvc.get_user_info user_name
      $scope.$watch 'lastfm_user.date_registered', ->
        cutoff_date = $scope.lastfm_user.date_registered
        return unless cutoff_date
        LastfmChartsSvc.get_weekly_chart_list_after_date user_name, cutoff_date

    unless $scope.load_status.neighbors
      LastfmChartsSvc.get_user_neighbors user_name

    $scope.slice_range = (array, count) ->
      range = []
      return range unless array
      if array.length > 0
        for i in [0...array.length] by count
          range.push i
      range
  ]
