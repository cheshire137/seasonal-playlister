'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.RdioPlaylistSvc
 # @description
 # # RdioPlaylistSvc
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'RdioPlaylistSvc', ['$q', '$http', ($q, $http) ->
    class RdioPlaylist
      create: (name, description, tracks) ->
        deferred = $q.defer()
        on_success = (data, status, headers, config) =>
          deferred.resolve(data)
        on_error = (data, status, headers, config) =>
          deferred.reject
            name: 'error_response'
            data: data
            status: status
            headers: headers
            config: config
        $http(
          url: '/rdio/playlist'
          method: 'POST'
          data:
            name: name
            description: description
            tracks: tracks
        ).success(on_success).error(on_error)
        deferred.promise

    new RdioPlaylist()
  ]
