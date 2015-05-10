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

    $scope.is_season_visible = (season, year) ->
      cur_date = new Date()
      return true if year < cur_date.getFullYear()
      cur_month = cur_date.getMonth() + 1 # e.g., 5 = May
      if season == 'spring' # March, April, May
        return true if cur_month >= 3 && cur_month < 6
      if season == 'summer' # June, July, August
        return true if cur_month >= 6 && cur_month < 9
      if season == 'fall' # September, October, November
        return true if cur_month >= 9 && cur_month < 12
      if season == 'winter' # January, February, December
        return true if cur_month >= 1 && cur_month < 3
        return true if cur_month == 12
      false
  ]
