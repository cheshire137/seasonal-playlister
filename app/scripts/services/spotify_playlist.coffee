'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.SpotifyPlaylistSvc
 # @description
 # # SpotifyPlaylistSvc
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'SpotifyPlaylistSvc', ['$q', '$http', ($q, $http) ->
    class SpotifyPlaylist
      create: (access_token, user_id, data) ->
        deferred = $q.defer()
        on_success = (data, status, headers, config) =>
          deferred.resolve data
        on_error = (data, status, headers, config) =>
          deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
        $http(
          url: "https://api.spotify.com/v1/users/#{user_id}/playlists"
          method: 'POST'
          headers:
            'Authorization': "Bearer #{access_token}"
            'Content-Type': 'application/json'
          data:
            name: data.name
            public: data.is_public
        ).success(on_success).error(on_error)
        deferred.promise

      add_tracks: (access_token, user_id, playlist, tracks) ->
        overall_deferred = $q.defer()
        url = "https://api.spotify.com/v1/users/#{user_id}/playlists/" +
              "#{playlist.id}/tracks"
        # See https://developer.spotify.com/web-api/add-tracks-to-playlist/
        # Maximum of 100 tracks added per request
        chunk_size = 100
        num_tracks = tracks.length
        if num_tracks <= chunk_size
          @add_chunk_of_tracks access_token, url, tracks, overall_deferred
          return overall_deferred.promise
        i = 0
        process_next_chunk = =>
          deferred = $q.defer()
          track_subset = tracks.slice(i, i + chunk_size)
          @add_chunk_of_tracks access_token, url, track_subset, deferred
          i += chunk_size
          deferred.promise
        on_chunk_success = ->
          if i < num_tracks
            process_next_chunk(i).then(on_chunk_success, on_chunk_error)
          else
            overall_deferred.resolve()
        on_chunk_error = (data, status, headers, config) =>
          console.error 'failed to add chunk', i, data
          overall_deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
        process_next_chunk(i).then(on_chunk_success, on_chunk_error)
        overall_deferred.promise

      add_chunk_of_tracks: (access_token, url, tracks, deferred) ->
        on_success = (data, status, headers, config) =>
          deferred.resolve()
        on_error = (data, status, headers, config) =>
          deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
        $http(
          url: url
          method: 'POST'
          headers:
            'Authorization': "Bearer #{access_token}"
            'Content-Type': 'application/json'
          data: tracks.map((track) -> track.uri)
        ).success(on_success).error(on_error)

    new SpotifyPlaylist()
  ]
