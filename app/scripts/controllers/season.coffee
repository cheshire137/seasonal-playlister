'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:SeasonCtrl
 # @description
 # # SeasonCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'SeasonCtrl', ($scope, $window, $routeParams, $cookieStore, NotificationSvc, LastfmChartsSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user
    $scope.load_status = LastfmChartsSvc.load_status
    $scope.year_charts = LastfmChartsSvc.year_charts
    $scope.year_chart = LastfmChartsSvc.chart
    $scope.track_filters =
      min_play_count: 3
      artist: 'all'
    $scope.season =
      name: $routeParams.season
      label: undefined

    $scope.wipe_notifications = ->
      NotificationSvc.wipe_notifications()

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
        unless $scope.year_chart.has_track(track)
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
      if $scope.year_chart.season_chart_count($scope.season.name) < 1
        $scope.year_chart.tracks_loaded = true
      else
        $scope.year_chart.each_season $scope.season.name, week_handler

    filter_tracks = ->
      return unless $scope.year_chart.tracks_loaded
      return unless $scope.track_filters
      $scope.year_chart.filter_tracks $scope.track_filters

    $scope.$watch 'year_chart.tracks_loaded', filter_tracks
    $scope.$watch 'track_filters.min_play_count', filter_tracks
    $scope.$watch 'track_filters.artist', filter_tracks

    $scope.download_csv = ->
      csv = $scope.year_chart.to_csv()
      $window.open(encodeURI(csv), '_blank')

    $scope.download_json = ->
      json = $scope.year_chart.to_json()
      url = 'data:application/json,' + json.replace(/([[{,])/g, '$1%0a')
      win = $window.open(url, '_blank')
      win.focus()
