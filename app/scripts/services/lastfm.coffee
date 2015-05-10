'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.lastfm
 # @description
 # # lastfm
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'LastfmSvc', ($timeout) ->
    class Lastfm
      constructor: ->
        @api_url = 'http://ws.audioscrobbler.com/2.0/'

      get_api_url: (method, params, callback) ->
        promise = null
        use_config = =>
          if promise
            $timeout.cancel promise
          url = @api_url + '?method=' + method
          url += '&api_key=' + window.seasonSoundConfig.lastfm_api_key + '&format=json'
          for key, value of params
            url += "&#{key}=#{encodeURIComponent(value)}"
          callback url
        if window.seasonSoundConfig
          use_config()
        else
          promise = $timeout(use_config, 500)

      get_user_neighbors_url: (user, callback) ->
        data =
          user: user
        @get_api_url 'user.getneighbours', data, callback

      get_user_info_url: (user, callback) ->
        data =
          user: user
        @get_api_url 'user.getinfo', data, callback

      get_weekly_chart_list_url: (user, callback) ->
        data =
          user: user
        @get_api_url 'user.getweeklychartlist', data, callback

      get_weekly_track_chart_url: (user, chart, callback) ->
        data =
          user: user
          from: chart.from
          to: chart.to
        @get_api_url 'user.getweeklytrackchart', data, callback

    new Lastfm()
