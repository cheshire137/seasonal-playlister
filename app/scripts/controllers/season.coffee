'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:SeasonCtrl
 # @description
 # # SeasonCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'SeasonCtrl', ($scope, $window, $routeParams, $cookieStore, NotificationSvc, LastfmChartsSvc, GoogleAuthSvc, GooglePlaylistSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user
    $scope.load_status = LastfmChartsSvc.load_status
    $scope.year_charts = LastfmChartsSvc.year_charts
    $scope.year_chart = LastfmChartsSvc.chart
    $scope.track_filters =
      min_play_count: $routeParams.min_play_count || 3
      artist: $routeParams.artist || 'all'
    $scope.season =
      name: $routeParams.season
      label: undefined
    $scope.auth_status =
      have_token: false
      access_token: $cookieStore.get('access_token')
      is_verified: false
    $scope.playlist =
      name: ''
      description: ''
      public: true

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

    $scope.$watch 'year_chart.tracks_loaded', ->
      filter_tracks()
      $scope.playlist.name = "#{$scope.lastfm_user.user_name} " +
                             "#{$scope.season.label} #{$scope.year_chart.year}"

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

    $scope.google_authenticate = ->
      GoogleAuthSvc.authenticate()

    $scope.$watch 'auth_status.access_token', ->
      $scope.auth_status.have_token = $scope.auth_status.access_token &&
                                      $scope.auth_status.access_token != ''
      return unless $scope.auth_status.have_token
      console.log 'access_token', $scope.auth_status.access_token
      on_success = (data) ->
        $scope.auth_status.is_verified = true
        $scope.auth_status.have_token = true
      on_error = ->
        $scope.auth_status.is_verified = false
        $scope.auth_status.access_token = ''
        $scope.auth_status.have_token = false
        $cookieStore.remove('access_token')
      GoogleAuthSvc.verify($scope.auth_status.access_token).
                then on_success, on_error

    $scope.create_playlist = ->
      console.log 'creating playlist'
      on_success = (data) ->
        console.log 'created playlist', data
      on_error = (data) ->
        console.error 'failed to create playlist', data
      GooglePlaylistSvc.create($scope.playlist).
                        then on_success, on_error
