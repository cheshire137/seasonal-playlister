'use strict'

###*
 # @ngdoc function
 # @name seasonSoundApp.controller:SeasonCtrl
 # @description
 # # SeasonCtrl
 # Controller of the seasonSoundApp
###
angular.module('seasonSoundApp')
  .controller 'SeasonCtrl', ['$scope', '$location', '$window', '$routeParams', '$cookieStore', 'NotificationSvc', 'LastfmChartsSvc', 'GoogleAuthSvc', 'GooglePlaylistSvc', 'RdioCatalogSvc', 'RdioPlaylistSvc', 'SpotifyAuthSvc', 'SpotifyCatalogSvc', 'SpotifyPlaylistSvc', ($scope, $location, $window, $routeParams, $cookieStore, NotificationSvc, LastfmChartsSvc, GoogleAuthSvc, GooglePlaylistSvc, RdioCatalogSvc, RdioPlaylistSvc, SpotifyAuthSvc, SpotifyCatalogSvc, SpotifyPlaylistSvc) ->
    $scope.lastfm_user = LastfmChartsSvc.user
    $scope.load_status = LastfmChartsSvc.load_status
    $scope.year_charts = LastfmChartsSvc.year_charts
    $scope.year_chart = LastfmChartsSvc.chart
    $scope.track_filters =
      min_play_count: 3
      artist: 'all'
    $scope.music_service =
      rdio: false
      google: false
      spotify: false
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
      spotify:
        have_token: false
        access_token: $cookieStore.get('spotify_access_token')
        user: $cookieStore.get('spotify_user')
    $scope.playlist =
      name: ''
      description: 'Created with SeasonSound.'
      is_public: true
    $scope.saved_playlist =
      id: null
    $scope.play_count_range = []
    $scope.page_info =
      page: 0
      per_page: 10
      total: 1

    $scope.go_back = ->
      NotificationSvc.wipe_notifications()
      LastfmChartsSvc.reset_charts()
      $scope.play_count_range.length = 0
      $scope.saved_playlist.id = null
      $scope.track_filters.min_play_count = 3
      $scope.track_filters.artist = 'all'
      $scope.music_service.rdio = false
      $scope.music_service.google = false
      $scope.music_service.spotify = false
      $scope.page_info.page = 0
      $scope.page_info.total = 1

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

    update_total_pages = ->
      total = Math.ceil($scope.year_chart.filtered_tracks.length /
                        $scope.page_info.per_page)
      total = 1 if total < 1
      $scope.page_info.total = total

    filter_tracks = ->
      return unless $scope.year_chart.tracks_loaded
      return unless $scope.track_filters
      $scope.year_chart.filter_tracks $scope.track_filters
      $scope.saved_playlist.id = null
      update_total_pages()
      if $scope.page_info.page > $scope.page_info.total
        $scope.page_info.page = 0
      max_play_count = $scope.year_chart.max_play_count()
      $scope.play_count_range =
          $scope.year_chart.get_play_count_range(max_play_count)
      if $scope.play_count_range.length < 1
        $scope.play_count_range.push 1

    $scope.$watch 'year_chart.tracks_loaded', ->
      return unless $scope.year_chart.tracks_loaded
      return unless $scope.track_filters
      max_play_count = $scope.year_chart.max_play_count()
      if max_play_count < $scope.track_filters.min_play_count
        $scope.track_filters.min_play_count = max_play_count
      $scope.play_count_range =
          $scope.year_chart.get_play_count_range(max_play_count)
      filter_tracks()
      $scope.playlist.name = "#{$scope.lastfm_user.user_name} " +
                             "#{$scope.season.label} #{$scope.year_chart.year}"

    $scope.$watch 'track_filters.min_play_count', filter_tracks
    $scope.$watch 'track_filters.artist', filter_tracks
    $scope.$watch 'year_chart.tracks.length', filter_tracks

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
      $cookieStore.put('user_return_to', $location.url())
      GoogleAuthSvc.authenticate()

    $scope.spotify_authenticate = ->
      $cookieStore.put('user_return_to', $location.url())
      state = Math.random().toString(36).substring(7)
      $cookieStore.put('spotify_state', state)
      SpotifyAuthSvc.authenticate(state)

    $scope.spotify_logout = ->
      $scope.auth_status.spotify.have_token = false
      $scope.auth_status.spotify.access_token = ''
      $scope.auth_status.spotify.user = ''
      $cookieStore.remove('spotify_access_token')
      $cookieStore.remove('spotify_user')

    $scope.rdio_authenticate = ->
      $cookieStore.put('user_return_to', $location.url())
      $window.location.href = '/auth/rdio'

    $scope.rdio_logout = ->
      $cookieStore.put('user_return_to', $location.url())
      $window.location.href = '/logout/rdio'

    $scope.$watch 'auth_status.rdio.user', ->
      user = $scope.auth_status.rdio.user
      $scope.auth_status.rdio.have_token = user && user != ''

    $scope.$watch 'auth_status.spotify.access_token', ->
      token = $scope.auth_status.spotify.access_token
      $scope.auth_status.spotify.have_token = token && token != ''
      return unless $scope.auth_status.spotify.have_token
      on_success = (data) ->
        $scope.auth_status.spotify.user = data.id
        $cookieStore.put('spotify_user', $scope.auth_status.spotify.user)
      on_error = ->
        $scope.auth_status.spotify.access_token = ''
        $scope.auth_status.spotify.have_token = false
        $cookieStore.remove('spotify_access_token')
      SpotifyAuthSvc.current_user(token).then on_success, on_error

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
      $scope.music_service.spotify = false
      $scope.saved_playlist.id = null
      $scope.year_chart.reset_track_flags()
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
      $scope.music_service.spotify = false
      $scope.saved_playlist.id = null
      $scope.year_chart.reset_track_flags()
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

    $scope.create_spotify_playlist = ->
      $scope.music_service.google = false
      $scope.music_service.rdio = false
      $scope.music_service.spotify = true
      $scope.saved_playlist.id = null
      $scope.year_chart.reset_track_flags()
      on_matched = (spotify_tracks) ->
        on_playlist_create = (spotify_playlist) ->
          $scope.saved_playlist.url = spotify_playlist.external_urls.spotify
          $scope.saved_playlist.id = spotify_playlist.id
          $scope.saved_playlist.name = spotify_playlist.name
          $scope.saved_playlist.is_public = spotify_playlist.public
          on_tracks_success = ->
            NotificationSvc.notice 'Created Spotify playlist!'
          on_tracks_error = (data) ->
            NotificationSvc.error 'Failed to add tracks to Spotify playlist.'
            console.error data.error.message
          SpotifyPlaylistSvc.add_tracks($scope.auth_status.spotify.access_token,
                                        $scope.auth_status.spotify.user,
                                        spotify_playlist, spotify_tracks).
                             then(on_tracks_success, on_tracks_error)
        on_playlist_error = (data) ->
          NotificationSvc.error 'Failed to create Spotify playlist.'
          console.error 'failed to create Spotify playlist', data
        SpotifyPlaylistSvc.create($scope.auth_status.spotify.access_token,
                                  $scope.auth_status.spotify.user,
                                  $scope.playlist).
                           then(on_playlist_create, on_playlist_error)
      on_match_error = ->
        console.error 'failed to match Spotify tracks to Last.fm tracks'
      SpotifyCatalogSvc.match_lastfm_tracks($scope.year_chart.filtered_tracks).
                        then(on_matched, on_match_error)
  ]
