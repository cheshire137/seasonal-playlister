'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.SpotifyCatalogSvc
 # @description
 # # SpotifyCatalogSvc
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'SpotifyCatalogSvc', ['$q', '$http', 'TrackCleanupSvc', ($q, $http, TrackCleanupSvc) ->
    class SpotifyCatalog
      get_track_search_url: (artist_name, track_name) ->
        track_query = encodeURIComponent(track_name)
        artist_query = encodeURIComponent(artist_name)
        "https://api.spotify.com/v1/search?q=track:#{track_query}%20" +
            "artist:#{artist_query}&type=track"

      match_lastfm_track: (index, lastfm_tracks, spotify_tracks, deferred) ->
        lastfm_track = lastfm_tracks[index]
        lastfm_track.matching = true
        proceed = =>
          if index < lastfm_tracks.length - 1
            @match_lastfm_track index + 1, lastfm_tracks, spotify_tracks,
                                deferred
          else
            deferred.resolve(spotify_tracks)
        found_spotify_track = (spotify_track) =>
          lastfm_track.matching = false
          lastfm_track.matched = true
          spotify_tracks.push spotify_track
          proceed()
        on_success = (spotify_track) =>
          found_spotify_track spotify_track
        on_first_error = =>
          clean_name = TrackCleanupSvc.clean_track_name(lastfm_track.name)
          on_second_error = =>
            lastfm_track.matching = false
            lastfm_track.missing = true
            proceed()
          @search_tracks_by_artist(lastfm_track.artist, clean_name).
              then(on_success, on_second_error)
        @search_tracks_by_artist(lastfm_track.artist, lastfm_track.name).
            then(on_success, on_first_error)

      match_lastfm_tracks: (lastfm_tracks) ->
        deferred = $q.defer()
        @match_lastfm_track 0, lastfm_tracks, [], deferred
        deferred.promise

      search_tracks_by_artist: (artist_name, track_name) ->
        deferred = $q.defer()
        on_success = (data, status, headers, config) =>
          if data.tracks && data.tracks.items && data.tracks.items.length > 0
            track = data.tracks.items[0]
            deferred.resolve track
          else
            deferred.reject
              name: 'missing_track'
              data: data
              status: status
              headers: headers
              config: config
        on_error = (data, status, headers, config) =>
          deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
        $http(
          url: @get_track_search_url(artist_name, track_name)
          method: 'GET'
        ).success(on_success).error(on_error)
        deferred.promise

    new SpotifyCatalog()
  ]
