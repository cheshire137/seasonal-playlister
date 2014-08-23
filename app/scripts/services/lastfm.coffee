'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.lastfm
 # @description
 # # lastfm
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'LastfmSvc', (ConfigSvc) ->
    class Lastfm
      constructor: ->
        @api_url = 'http://ws.audioscrobbler.com/2.0/'

      get_api_url: (method, params) ->
        url = @api_url + '?method=' + method
        url += '&api_key=' + ConfigSvc.lastfm_api_key + '&format=json'
        for key, value of params
          url += "&#{key}=#{encodeURIComponent(value)}"
        url

      get_user_neighbors_url: (user) ->
        @get_api_url 'user.getneighbours',
          user: user

      get_user_info_url: (user) ->
        @get_api_url 'user.getinfo',
          user: user

      get_weekly_chart_list_url: (user) ->
        @get_api_url 'user.getweeklychartlist',
          user: user

    new Lastfm()
