'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:SeasonCtrl
 # @description
 # # SeasonCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'SeasonCtrl', ($scope, $routeParams, $cookieStore, LastfmChartsSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user
    $scope.load_status = LastfmChartsSvc.load_status
    $scope.year_charts = LastfmChartsSvc.year_charts
    $scope.year_chart = LastfmChartsSvc.chart
    $scope.season =
      name: $routeParams.season
      label: undefined

    $scope.season.label = $scope.season.name.charAt(0).toUpperCase() +
                          $scope.season.name.slice(1)

    unless $routeParams.user == $cookieStore.get('lastfm_user')
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

    on_week_chart_loaded = (week_chart, is_last) ->
      for track in week_chart.tracks
        $scope.year_chart.tracks.push track
      if is_last
        $scope.year_chart.tracks_loaded = true

    week_handler = (week_chart, index, is_last) ->
      user = $scope.lastfm_user.user_name
      handler = ->
        on_week_chart_loaded week_chart, is_last
      LastfmChartsSvc.get_weekly_track_chart user, week_chart, handler

    $scope.$watch 'load_status.charts', ->
      return unless $scope.load_status.charts
      LastfmChartsSvc.load_year_chart $routeParams.year
      $scope.year_chart.each_season $scope.season.name, week_handler
