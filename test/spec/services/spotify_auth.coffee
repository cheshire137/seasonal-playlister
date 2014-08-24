'use strict'

describe 'Service: spotifyAuth', ->

  # load the service's module
  beforeEach module 'seasonSoundApp'

  # instantiate service
  spotifyAuth = {}
  beforeEach inject (_spotifyAuth_) ->
    spotifyAuth = _spotifyAuth_

  it 'should do something', ->
    expect(!!spotifyAuth).toBe true
