'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.GoogleAuthSvc
 # @description
 # # GoogleAuthSvc
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'GoogleAuthSvc', ($q, $cookieStore, $location, $window) ->
    class GoogleAuth
      constructor: ->
        @auth_endpoint = 'https://accounts.google.com/o/oauth2/auth'
        @client_id = '1098051467131-5nfhjfn7maf7tc54abh3uk7c27m1g9e1.apps.googleusercontent.com'
        @redirect_uri = 'http://localhost:9292'
        @scopes = ['https://www.googleapis.com/auth/musicmanager']

      authenticate: ->
        $cookieStore.put('user_return_to', $location.url())
        params =
          response_type: 'token'
          client_id: @client_id
          redirect_uri: @redirect_uri
          scope: @scopes.join(' ')
        query_params = []
        for key, value of params
          query_params.push(encodeURIComponent(key) + '=' +
                            encodeURIComponent(value))
        query_str = query_params.join('&')
        url = @auth_endpoint + '?' + query_str
        $window.location.href = url

      verify: (access_token) ->
        $injector = angular.injector(['ng'])
        client_id = @client_id
        $injector.invoke(['$http', '$rootScope', ($http, $rootScope) ->
          deferred = $q.defer()
          $rootScope.$apply ->
            on_success = (data) ->
              if data.audience == client_id
                deferred.resolve(data)
              else
                deferred.reject({name: 'invalid_audience'})
            on_error = (data, status, headers, config) ->
              deferred.reject
                name: 'error_response'
                data: data
                status: status
                headers: headers
                config: config
            $http({
              method: 'GET',
              url: 'https://www.googleapis.com/oauth2/v1/tokeninfo',
              params: {access_token: access_token}
            }).success(on_success).error(on_error)
          deferred.promise
        ])

    new GoogleAuth()
