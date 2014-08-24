'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.RdioCatalogSvc
 # @description
 # # RdioCatalogSvc
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'RdioCatalogSvc', ['$http', 'TrackCleanupSvc', ($http, TrackCleanupSvc) ->
    class RdioCatalog
      get_artist_search_url: (artist_name) ->
        query = encodeURIComponent(artist_name)
        "/rdio/search/artist?query=#{query}"

      get_track_search_url: (artist_id, track_name) ->
        query = encodeURIComponent(track_name)
        "/rdio/search/track?artist_id=#{artist_id}&query=#{query}"

      match_lastfm_track: (index, lastfm_tracks, rdio_tracks, callback) ->
        lastfm_track = lastfm_tracks[index]
        lastfm_track.matching = true
        proceed = =>
          if index < lastfm_tracks.length - 1
            @match_lastfm_track index + 1, lastfm_tracks, rdio_tracks, callback
          else
            callback rdio_tracks
        found_rdio_track = (rdio_track) =>
          lastfm_track.matching = false
          lastfm_track.matched = true
          rdio_tracks.push rdio_track
          proceed()
        @search_artists lastfm_track.artist, (artist) =>
          if artist
            @search_tracks_by_artist artist.id, lastfm_track.name, (rdio_track) =>
              if rdio_track
                found_rdio_track rdio_track
              else
                # Attempt 2!
                clean_name = TrackCleanupSvc.clean_track_name(lastfm_track.name)
                @search_tracks_by_artist artist.id, clean_name, (rdio_track) =>
                  if rdio_track
                    found_rdio_track rdio_track
                  else
                    # Too bad :(
                    lastfm_track.matching = false
                    lastfm_track.missing = true
                    proceed()
          else
            lastfm_track.matching = false
            lastfm_track.missing = true
            proceed()

      match_lastfm_tracks: (lastfm_tracks, on_matched_all) ->
        @match_lastfm_track 0, lastfm_tracks, [], on_matched_all

      search_tracks_by_artist: (artist_id, track_name, callback) ->
        on_success = (data, status, headers, config) =>
          if data.error
            console.log data.error
            callback undefined
          else
            callback data
        on_error = (data, status, headers, config) =>
          console.error 'search_tracks_by_artist failure', artist_id,
                        track_name, data
        $http(
          url: @get_track_search_url(artist_id, track_name)
          method: 'GET'
        ).success(on_success).error(on_error)

      search_artists: (artist_name, callback) ->
        on_success = (data, status, headers, config) =>
          if data.error
            callback undefined
          else
            callback data
        on_error = (data, status, headers, config) =>
          console.error 'search_artists failure', artist_name, data
        $http(
          url: @get_artist_search_url(artist_name)
          method: 'GET'
        ).success(on_success).error(on_error)

    new RdioCatalog()
  ]
