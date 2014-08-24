'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.SpotifyAuthSvc
 # @description
 # # SpotifyAuthSvc
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'SpotifyAuthSvc', ['$q', '$location', '$window', '$http', '$timeout', ($q, $location, $window, $http, $timeout) ->
    class SpotifyAuth
      constructor: ->
        @auth_endpoint = 'https://accounts.spotify.com/authorize'
        @client_id = '48843220ee99406d8129b1d710434cd4'
        @redirect_uri = $window.location.origin
        @scopes = ['playlist-modify-public', 'playlist-modify-private']

      authenticate: (state) ->
        params =
          response_type: 'token'
          client_id: @client_id
          redirect_uri: @redirect_uri
          scope: @scopes.join(' ')
          state: state
        query_params = []
        for key, value of params
          query_params.push(encodeURIComponent(key) + '=' +
                            encodeURIComponent(value))
        query_str = query_params.join('&')
        url = @auth_endpoint + '?' + query_str
        $window.location.href = url

      current_user: (access_token) ->
        deferred = $q.defer()
        attempts = 0
        on_success = (data) ->
          deferred.resolve(data)
        on_error = (data, status, headers, config) ->
          # Bad Gateway, happens sometimes with Spotify
          if status == 502 && attempts < 3
            $timeout make_request, 2000
          else
            deferred.reject
              name: 'error_response'
              data: data
              status: status
              headers: headers
              config: config
        make_request = ->
          $http({
            method: 'GET'
            headers:
              'Authorization': "Bearer #{access_token}"
            url: 'https://api.spotify.com/v1/me'
          }).success(on_success).error(on_error)
          attempts += 1
        make_request()
        deferred.promise

    new SpotifyAuth()
  ]
