'use strict'

###*
 # @ngdoc service
 # @name seasonSoundApp.config
 # @description
 # # config
 # Service in the seasonSoundApp.
###
angular.module('seasonSoundApp')
  .service 'ConfigSvc', class Config
    constructor: ->
      @lastfm_api_key = 'ea054bf733870992a8b83f4b9c1cbe7a'
