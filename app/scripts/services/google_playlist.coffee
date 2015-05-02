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
      create: (playlist, access_token) ->
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
        $http(
          method: 'POST'
          url: '/google/playlist'
          params:
            name: playlist.name
            description: playlist.description
            is_public: playlist.is_public
            access_token: access_token
        ).success(on_success).error(on_error)
        deferred.promise

    new GooglePlaylist()
