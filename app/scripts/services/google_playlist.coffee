'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.googlePlaylist
 # @description
 # # googlePlaylist
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'GooglePlaylistSvc', ($q, $http) ->
    class GooglePlaylist
      constructor: ->
        @headers =
          'User-agent': 'Music Manager (1, 0, 55, 7425 HTTPS - Windows)'
        @url = 'https://play.google.com/music/services/createplaylist'
        @params =
          format: 'jsarray'

      create: (playlist) ->
        console.log 'creating playlist', playlist
        deferred = $q.defer()
        on_success = (data) ->
          deferred.resolve(data)
        on_error = (data, status, headers, config) ->
          deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
        $http({
          method: 'POST',
          url: @url,
          params:
            create:
              creationTimestamp: '-1'
              deleted: false
              lastModifiedTimestamp: '0'
              name: playlist.name
              type: 'USER_GENERATED'
              accessControlled: !playlist.is_public
        }).success(on_success).error(on_error)

    new GooglePlaylist()
