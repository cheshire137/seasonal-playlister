'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:SeasonCtrl
 # @description
 # # SeasonCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'SeasonCtrl', ['$scope', '$location', '$window', '$routeParams', '$cookieStore', 'NotificationSvc', 'LastfmChartsSvc', 'GoogleAuthSvc', 'GooglePlaylistSvc', 'RdioCatalogSvc', 'RdioPlaylistSvc', ($scope, $location, $window, $routeParams, $cookieStore, NotificationSvc, LastfmChartsSvc, GoogleAuthSvc, GooglePlaylistSvc, RdioCatalogSvc, RdioPlaylistSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user
    $scope.load_status = LastfmChartsSvc.load_status
    $scope.year_charts = LastfmChartsSvc.year_charts
    $scope.year_chart = LastfmChartsSvc.chart
    $scope.track_filters =
      min_play_count: $routeParams.min_play_count || 3
      artist: $routeParams.artist || 'all'
    $scope.music_service =
      rdio: false
      google: false
    $scope.season =
      name: $routeParams.season
      label: undefined
    $scope.auth_status =
      google:
        have_token: false
        access_token: $cookieStore.get('google_access_token')
        is_verified: false
      rdio:
        have_token: false
        user: $cookieStore.get('rdio_user')
    $scope.playlist =
      name: ''
      description: 'Created with SeasonSound.'
      is_public: true
    $scope.saved_playlist =
      id: null

    $scope.go_back = ->
      NotificationSvc.wipe_notifications()
      $scope.saved_playlist.id = null

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
      on_success = ->
        on_week_chart_loaded week_chart, is_last
      on_error = ->
        $scope.year_chart.tracks_loaded = true
      LastfmChartsSvc.get_weekly_track_chart(user, week_chart).
                      then(on_success, on_error)

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
      $scope.saved_playlist.id = null

    $scope.$watch 'year_chart.tracks_loaded', ->
      return unless $scope.year_chart.tracks_loaded
      return unless $scope.track_filters
      max_play_count = $scope.year_chart.max_play_count()
      if max_play_count < $scope.track_filters.min_play_count
        $scope.track_filters.min_play_count = max_play_count
      filter_tracks()
      $scope.playlist.name = "#{$scope.lastfm_user.user_name} " +
                             "#{$scope.season.label} #{$scope.year_chart.year}"

    $scope.$watch 'track_filters.min_play_count', filter_tracks
    $scope.$watch 'track_filters.artist', filter_tracks

    $scope.download_csv = ->
      csv = $scope.year_chart.to_csv()
      win = $window.open(encodeURI(csv), '_blank')
      win.focus()

    $scope.download_json = ->
      json = $scope.year_chart.to_json()
      url = 'data:application/json,' + json.replace(/([[{,])/g, '$1%0a')
      win = $window.open(url, '_blank')
      win.focus()

    $scope.google_authenticate = ->
      GoogleAuthSvc.authenticate()

    $scope.rdio_authenticate = ->
      $cookieStore.put('user_return_to', $location.url())
      $window.location.href = '/auth/rdio'

    $scope.rdio_logout = ->
      $cookieStore.put('user_return_to', $location.url())
      $window.location.href = '/logout/rdio'

    $scope.$watch 'auth_status.rdio.user', ->
      user = $scope.auth_status.rdio.user
      $scope.auth_status.rdio.have_token = user && user != ''

    $scope.$watch 'auth_status.google.access_token', ->
      token = $scope.auth_status.google.access_token
      $scope.auth_status.google.have_token = token && token != ''
      return unless $scope.auth_status.have_token
      on_success = (data) ->
        $scope.auth_status.google.is_verified = true
        $scope.auth_status.google.have_token = true
      on_error = ->
        $scope.auth_status.google.is_verified = false
        $scope.auth_status.google.access_token = ''
        $scope.auth_status.google.have_token = false
        $cookieStore.remove('google_access_token')
      GoogleAuthSvc.verify(token).then on_success, on_error

    $scope.create_google_playlist = ->
      $scope.music_service.google = true
      $scope.music_service.rdio = false
      $scope.saved_playlist.id = null
      on_success = (data) ->
        NotificationSvc.notice 'Created Google Music playlist!'
        console.log 'created Google Music playlist', data
      on_error = (data) ->
        NotificationSvc.error 'Failed to create Google Music playlist.'
        console.error 'failed to create Google Music playlist', data
      GooglePlaylistSvc.create($scope.playlist,
                               $scope.auth_status.access_token).
                        then(on_success, on_error)

    $scope.create_rdio_playlist = ->
      $scope.music_service.google = false
      $scope.music_service.rdio = true
      $scope.saved_playlist.id = null
      on_matched = (rdio_tracks) ->
        on_success = (data) ->
          NotificationSvc.notice 'Created Rdio playlist!'
          for key, value of data
            $scope.saved_playlist[key] = value
        on_error = (data) ->
          NotificationSvc.error 'Failed to create Rdio playlist.'
          console.error 'failed to create Rdio playlist', data
        track_ids = (track.id for track in rdio_tracks)
        track_ids_str = track_ids.join(',')
        RdioPlaylistSvc.create($scope.playlist.name,
                               $scope.playlist.description,
                               track_ids_str).then(on_success, on_error)
      RdioCatalogSvc.match_lastfm_tracks $scope.year_chart.filtered_tracks,
                                         on_matched
  ]
