'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.SpotifyAuthSvc
 # @description
 # # SpotifyAuthSvc
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'SpotifyAuthSvc', ['$q', '$location', '$window', ($q, $location, $window) ->
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

    new SpotifyAuth()
  ]
