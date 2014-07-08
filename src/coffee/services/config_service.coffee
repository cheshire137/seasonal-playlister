seasonal_app.factory 'ConfigSvc', ->
  class Config
    constructor: ->
      @lastfm_api_key = 'ea054bf733870992a8b83f4b9c1cbe7a'

  new Config()
